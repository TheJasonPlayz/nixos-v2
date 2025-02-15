{ username, ... }:

{
  imports = [
    ./common { inherit username; }
  ];
}