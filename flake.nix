{
  inputs.nixpkgs.url = "nixpkgs/nixos-unstable";
  inputs.organist.url = "github:nickel-lang/organist";
  inputs.json-schema-to-nickel.url = "github:nickel-lang/json-schema-to-nickel";

  nixConfig = {
    extra-substituters = ["https://tweag-nickel.cachix.org"];
    extra-trusted-public-keys = ["tweag-nickel.cachix.org-1:GIthuiK4LRgnW64ALYEoioVUQBWs0jexyoYVeLDBwRA="];
  };

  outputs = {organist, ...} @ inputs:
    organist.flake.outputsFromNickel ./. inputs {};
}
