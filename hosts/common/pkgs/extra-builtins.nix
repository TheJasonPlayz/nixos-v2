{ extraBuiltins, ... }: {
  readSops = name: extraBuiltins.exec [ "sops" "-d" name ];
}