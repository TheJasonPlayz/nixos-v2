{ username, config, ... }:

{
  users.users.${username} = {
    isNormalUser = true;
    description = "Jason Whitman";
    extraGroups = [ "wheel" ];
    openssh.authorizedKeys.keyFiles = [ ];
  };
}