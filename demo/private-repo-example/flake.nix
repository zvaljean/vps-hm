{
  description = "Private per-machine Home Manager modules";

  outputs = {self}: let
    machinesDir = ./machines;
    machineFiles = builtins.readDir machinesDir;

    remoteNixSuffixFn = filename: builtins.substring 0 (builtins.stringLength filename - 4) filename;

    # 文件过滤器，只筛选出nix文件
    fileFilterFn = filename:
      machineFiles.${filename}
      == "regular"
      && builtins.substring 0 1 filename != "_"
      && builtins.match ".+\\.nix" filename != null;

    hostnames =
      map remoteNixSuffixFn
      (builtins.filter fileFilterFn
        (builtins.attrNames machineFiles));

    fn = hostname: {
      name = hostname;
      value = ./machines/${hostname}.nix;
    };
  in {
    homeManagerModules = builtins.listToAttrs (map fn hostnames);
  };
}
