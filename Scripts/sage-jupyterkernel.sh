#!/usr/bin/env bash

sagePkg="/etc/nixos#nixosConfigurations.pc.pkgs.sage"
sageBin=$(nix eval "$sagePkg.outPath" | tr -d \")
sageBin="$sageBin/bin/sage"
mkdir ./sage-kernel
echo "{\"argv\": [\"$sageBin\", \"--python\", \"-m\", \"sage.repl.ipython_kernel\", \"-f\", \"{connection_file}\"], \"display_name\": \"SageMath $(nix eval "$sagePkg.version" | tr -d \")\", \"language\": \"sage\"}" > ./sage-kernel/kernel.json
sudo jupyter kernelspec install ./sage-kernel
rm -rf ./sage-kernel/