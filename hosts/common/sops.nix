{ username, ... }:

{
  sops = {
    defaultSopsFile = ../../secrets.yaml;
    age = {
      sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];
      sops.age.keyFile = "/home/${username}/.config/sops/age/keys.txt";

      sops.secrets = {
        "github/pac" = {};
        "ssh/priv_key" = {};
      };
    };
  };
}