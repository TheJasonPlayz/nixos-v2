let 
  version = "xmage_1.4.56V3";
  url = "https://github.com/magefree/mage/releases/download/xmage_1.4.56V3/mage-full_1.4.56-dev_2025-02-09_16-07.zip";
  installPhaseVer = final: ver: final.lib.substring 6 ( (builtins.stringLength ver) - 6 - 2 ) (builtins.replaceStrings ["b"] [""] ver);
  xmage-server = final: ''
    sed -i 's_java_${final.jdk8}/bin/java_g' $out/xmage/mage-server/startServer.sh
    sed -i "s#\./.*#$out/xmage/mage-server/lib/mage-server-${installPhaseVer final version}.jar#g" $out/xmage/mage-server/startServer.sh
    cat << EOS > $out/bin/xmage-server
    exec $out/xmage/mage-server/startServer.sh
    EOS

    chmod +x $out/xmage/mage-server/startServer.sh
    chmod +x $out/bin/xmage-server
  '';
in 
final: prev: {
  xmage = prev.xmage.overrideAttrs (oldAttrs: {
    inherit version;

    src = final.fetchurl {
      inherit url;
      sha256 = "sha256-zpCUDApYZXHDEjwFOtg+L/5Es4J96F4Z2ojFcrzYumo=";
    };

    installPhase = builtins.replaceStrings ["1.4.50"] [ (installPhaseVer final version) ] oldAttrs.installPhase + (xmage-server final);
  });
}
 