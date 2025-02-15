{ stdenv, config, ... }:

{
  
}
# stdenv.mkDerivation rec {
#     name = "ssh_privkey";
#     pname = name;

#     src = config.sops.secrets."ssh/priv_key".source;


#     installPhase = ''
#       mkdir $out
#       cp $ssh $out/id_ed25519
#     '';

#     dontUnpack = true;
# }