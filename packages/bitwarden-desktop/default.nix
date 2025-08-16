{pkgs, ...}: let
  base = pkgs.bitwarden-desktop;

  desktop_proxy = pkgs.rustPlatform.buildRustPackage {
    inherit (base) version;
    pname = "bitwarden-desktop-proxy";
    src = "${base.src}/apps/desktop/desktop_native";
    cargoLock = {
      lockFile = "${base.src}/apps/desktop/desktop_native/Cargo.lock";
      allowBuiltinFetchGit = true;
    };
    doCheck = false;
  };
in
  pkgs.stdenv.mkDerivation {
    inherit (base) version pname;
    doCheck = false;
    src = base;

    buildPhase = ''
      substituteInPlace ./bin/bitwarden --replace-fail '${base}' "$out";
      sed -i ./opt/Bitwarden/resources/app.asar -e "s|${base}|$out|g";
      mkdir -p ./lib/mozzila/native-messaging-hosts/
      cat <<EOF >./lib/mozzila/native-messaging-hosts/com.8bit.bitwarden.json
      {
        "name": "com.8bit.bitwarden",
        "description": "Bitwarden desktop <-> browser bridge",
        "path": "$out/bin/desktop_proxy",
        "type": "stdio",
        "allowed_extensions": [
          "{446900e4-71c2-419f-a6a7-df9c091e268b}"
        ]
      }
      EOF
    '';

    installPhase = ''
      cp -r ./ $out
      ln -s ${desktop_proxy}/bin/desktop_proxy $out/bin/desktop_proxy
    '';
  }
