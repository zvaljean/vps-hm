#!/usr/bin/env bash
set -euo pipefail

hostname="$(hostname -s)"
exec nix run home-manager -- switch --flake ".#${hostname}"
