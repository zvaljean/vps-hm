# 私有机器配置 Flake 示例

这个目录演示如何把每台机器不同的 Home Manager 配置放在一个独立的私有 Flake 仓库中。

目录关系可以是：

```text
公共配置仓库
├── flake.nix
├── common.nix
└── demo/

私有配置仓库
├── flake.nix
└── machines/
    ├── vps01.nix
    └── vps02.nix
```

## 工作方式

公共仓库的 [`flake.nix`](./flake.nix) 通过 SSH 声明私有仓库：

```nix
private-config.url = "git+ssh://git@git.example.com/infra/home-manager-private.git?ref=main";
```

私有仓库通过 `homeManagerModules` 暴露每台机器的模块。公共仓库为每个 hostname 暴露一个 Home Manager Flake 输出：

```nix
homeConfigurations = builtins.mapAttrs (_hostname: machineModule:
  home-manager.lib.homeManagerConfiguration {
    modules = [ ./common.nix machineModule ];
  }
) private-config.homeManagerModules;
```

`homeManagerModules` 的 attrset key 可以使用动态变量。示例中的私有 Flake 使用 hostname 列表动态生成 key：

```nix
homeManagerModules = builtins.listToAttrs (map (hostname: {
  name = hostname;
  value = ./machines/${hostname}.nix;
}) hostnames);
```

示例中的 `hostnames` 不是手写的，而是扫描 `machines/` 目录下的普通 `.nix` 文件，
忽略以下划线开头的文件，并去掉文件名后缀得到。例如 `machines/vps01.nix` 会生成
hostname `vps01`，而 `_template.nix` 会被忽略。

hostname 适合作为稳定的机器标识。IP 地址也可以作为 key，例如
`"192.0.2.10"`，但通常不建议这样做，因为 IP 可能变化；如果确实需要，可以使用同样的动态 attrset 写法。

纯 Flake 求值不能读取当前系统的 hostname。为了保持纯求值，hostname 由 Flake
外部的脚本读取，再作为输出名称传给 Home Manager：

```sh
hostname="$(hostname -s)"
nix run home-manager -- switch --flake ".#${hostname}"
```

本目录的 [`switch-by-hostname.sh`](./switch-by-hostname.sh) 已包含这段逻辑，可以直接执行：

```sh
bash ./switch-by-hostname.sh
```

这样不需要 `--impure`。系统 hostname 必须与私有仓库中的模块 key 和文件名一致，
例如 `vps01` 对应 `homeManagerModules.vps01` 和 `machines/vps01.nix`。

SSH URL 不包含密码或访问令牌，访问权限由目标机器上的 SSH agent、SSH key 和 Git 服务器权限控制。

第一次使用或更新锁定版本时，在目标机器上执行：

```sh
nix flake lock --update-input private-config
```

之后 Flake lock 文件会固定私有配置仓库的 revision。需要更新私有配置时再显式更新该 input。

`private-repo-example/` 只是私有仓库应有结构的示例；实际使用时应将其作为独立的私有 Git 仓库，而不是放进公共仓库。
