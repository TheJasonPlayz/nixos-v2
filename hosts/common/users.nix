{ username, ... }:

{
  users.users.${username} = {
    isNormalUser = true;
    description = "Jason Whitman";
    extraGroups = [ "wheel" ];
  };
}