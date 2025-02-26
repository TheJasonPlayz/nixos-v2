final: prev:
{
  badlion-client = prev.badlion-client.overrideAttrs (oldAttrs: {
    version = "4.4.1";
    src.url = "https://client-updates-cdn77.badlion.net/BadlionClient";
  });
}