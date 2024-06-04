let gha = import "./out/GitHub Workflow.ncl" in

let install_nix = {
  name = "Install Nix",
  uses = "cachix/install-nix-action@v26"
}
in

{
  update-flake-lock = {
    jobs.update-flake-lock = {
      runs-on = "ubuntu-latest",
      steps = [
        install_nix,
          {
            name = "Update flake.lock",
            uses = "DeterminateSystems/update-flake-lock@v21",
          }
      ],
    },
    on = "push",
  },

  ensure-up-to-date-schemas = {
    jobs.test = {
      runs-on = "ubuntu-latest",
      steps = [
        install_nix,
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
