.DEFAULT_GOAL := usage
.NOTPARALLEL:

CONFIG ?= $(shell id -un)
FLAKE ?= .
HM ?= home-manager
HM_ARGS ?=
BACKUP ?= backup

.PHONY: usage help build switch dry-run generations packages news lock update

usage help:
	@printf '%s\n' \
	  'Usage: make <target> [CONFIG=data|root] [HM_ARGS="..."]' \
	  '' \
	  'Targets:' \
	  '  usage/help   显示此说明（默认目标）' \
	  '  build        构建配置，不激活' \
	  '  switch       构建并激活配置，冲突文件备份为 .backup' \
	  '  dry-run      预览切换操作，不激活；仍可能求值、下载或构建' \
	  '  generations  查看当前用户的历史代次' \
	  '  packages     查看当前用户已激活的软件包' \
	  '  news         查看所选配置的 Home Manager 消息' \
	  '  lock         补齐 flake.lock，保留已有输入锁定' \
	  '  update       更新全部 flake 输入，不激活配置' \
	  '' \
	  'Variables:' \
	  '  CONFIG       配置名称，默认为当前用户名；现有入口为 data、root' \
	  '  FLAKE        flake 路径，默认 .' \
	  '  HM           Home Manager 命令，默认 home-manager' \
	  '  HM_ARGS      额外 Home Manager 参数' \
	  '  BACKUP       switch 的备份后缀，默认 backup' \
	  '' \
	  'Examples:' \
	  '  make build CONFIG=data' \
	  '  make dry-run CONFIG=data' \
	  '  make switch CONFIG=root' \
	  '' \
	  '请先从 Org 源文件 tangle 最新配置；本 Makefile 不自动生成 Nix 文件。' \
	  'build、switch 和 dry-run 均使用 --no-out-link，不生成 result 链接。' \
	  '同一次 make 内串行执行目标；请勿在多个终端同时部署。' \
	  'switch 应在对应用户的登录环境执行；CONFIG=root 不会自动提权。'

build:
	$(HM) build --flake "$(FLAKE)#$(CONFIG)" --no-out-link $(HM_ARGS)

switch:
	$(HM) switch --flake "$(FLAKE)#$(CONFIG)" --no-out-link -b "$(BACKUP)" $(HM_ARGS)

dry-run:
	$(HM) switch --flake "$(FLAKE)#$(CONFIG)" --no-out-link --dry-run $(HM_ARGS)

generations:
	$(HM) generations $(HM_ARGS)

packages:
	$(HM) packages $(HM_ARGS)

news:
	$(HM) news --flake "$(FLAKE)#$(CONFIG)" $(HM_ARGS)

lock:
	nix flake lock "$(FLAKE)"

update:
	nix flake update --flake "$(FLAKE)"
