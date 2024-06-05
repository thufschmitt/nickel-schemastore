let gha = import "./out/GitHub Workflow.ncl" in

let setup = [
  {
    name = "Checkout",
    uses = "actions/checkout@v2",
  },
  {
    name = "Install Nix",
    uses = "cachix/install-nix-action@v26",
    with.extra_nix_config = "accept-flake-config = true",
  },
  {
    uses = "cachix/cachix-action@v14",
    with.name = "nickel-schemastore",
    with.authToken = "${{ secrets.CACHIX_AUTH_TOKEN }}",
  },
]
in

{
  update-flake-lock = {
    jobs.update-flake-lock = {
      runs-on = "ubuntu-latest",
      steps =
        setup
        @ [
          {
            name = "Update flake.lock",
            uses = "DeterminateSystems/update-flake-lock@v21",
          }
        ],
    },
    on.schedule = [ { cron = "0 0 * * 0" } ],
  },

  ensure-up-to-date-schemas = {
    jobs.test = {
      runs-on = "ubuntu-latest",
      steps =
        setup
        @ [
          {
            name = "Ensure that schema files don't need a rebuild",
            run = m%"
          nix develop --command python3 ./extract-schemas.py
          git diff --exit-code
        "%,
          }
        ],
    },
    on = "push",
  }
} | { _ | gha }
