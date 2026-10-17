# 项目协作说明

## 项目性质

- 本项目是用于远端 VPS 的 Home Manager 配置。
- 当前工作目录不一定是配置的目标主机。
- 不要在本机激活此 Home Manager 配置，也不要在本机启动、停止或重启配置中定义的服务。

## 配置来源

- `content-org/hm-vps.org` 是本项目配置的主要来源。
- 仓库中的 Nix 文件由 `content-org/hm-vps.org` 生成。
- 修改配置时，应先修改 `content-org/hm-vps.org` 中对应的 subtree，而不是直接修改生成的 Nix 文件。
- 只有用户明确要求时，才执行 Org Babel tangle 或其他生成操作。

## 验证与执行

- 只有用户明确要求时，才运行 Nix 求值、构建、格式化或 Home Manager 检查。
- 未经用户明确要求，不执行 `home-manager switch`、`nixos-rebuild` 或任何会激活配置的命令。
- 不在本机运行配置中声明的程序或 systemd 服务来验证远端配置。
- 如果无法在不激活配置的情况下验证，应说明未验证的内容，不要自行扩大执行范围。

## 编辑原则

- 保持现有 Org 文档结构和代码块风格。
- 新配置应放入语义对应的 subtree，并使用正确的 `:tangle` 目标。
- 不覆盖或撤销与当前任务无关的用户修改。
- 除非用户明确要求，不提交 Git commit，也不修改 Git 暂存区。

## 敏感信息

- 不要把密码、访问令牌、私钥等敏感信息直接写入仓库。
- 涉及 Nix Store 时，应提醒用户：通过 Nix 声明生成的敏感内容可能在 Nix Store 中对本机用户可读。
