{ username, ... }:

{
  sops = {
    defaultSopsFile = ../../secrets.yaml;
    age = {
      sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];
      keyFile = "/home/${username}/.config/sops/age/keys.txt";
    };
    secrets = {
      "github/pac" = {};
      "ssh/priv_key" = {};
    };
  };
}