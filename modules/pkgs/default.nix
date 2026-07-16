# https://nix-community.github.io/home-manager/index.xhtml#sec-module-auto-importing
{ lib, ... }:
let
  dir = builtins.readDir ./.;
  autoImportFilter = name: type:
    let
      isValidFile = type == "regular" && name != "default.nix" && lib.strings.hasSuffix ".nix" name;
      isValidDir = type == "directory";
      isNotIgnored = !(lib.strings.hasPrefix "_" name);
    in
      isNotIgnored && (isValidFile || isValidDir);

  validModules = builtins.filter (name: autoImportFilter name dir.${name}) (builtins.attrNames dir);
in
{
  imports = map (name: ./${name}) validModules;
}
