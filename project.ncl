let inputs = import "./nickel.lock.ncl" in
let organist = inputs.organist in

{
  shells = organist.shells.Bash,

  shells.build = {
    packages.json-schema-to-nickel = organist.import_nix "json-schema-to-nickel#default",
    packages.python = organist.import_nix "nixpkgs#python3",
  },

  shells.dev = {
    packages.hello = organist.import_nix "nixpkgs#hello",
  },

  files =
    (import "./gh-actions.ncl")
    |> std.record.to_array
    |> std.array.map
      (
        fun { field = workflow_name, value = workflow } =>
          {
            field = ".github/workflows/%{workflow_name}.yml",
            value.content = std.serialize 'Yaml workflow
          }
      )
    |> std.record.from_array,
}
  | organist.OrganistExpression
