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
            env.GH_TOKEN = "${{ github.token }}",
            name = "Ensure that schema files don't need a rebuild",
            run = m%"
          nix develop --command python3 ./extract-schemas.py
          if ! git diff --exit-code; then
            git add .
            git config user.name "Schemas update bot"
            git config user.email "noreply@schemaupdate.invalid"
            git commit --message="Re-generate the schema files"
            nix run --inputs-from . nixpkgs\#gh -- pr create \
              --title "Re-generate the schema files" \
              --body "Automated update from {{ env.GITHUB_RUN_ID }}"
          fi
        "%,
          }
        ],
    },
    on.schedule = [ { cron = "0 0 * * 0" } ],
    on.workflow_dispatch = {},
    on.push = {},
  }
} | { _ | gha }
