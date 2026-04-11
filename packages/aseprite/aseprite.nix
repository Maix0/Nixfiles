{
  inputs,
  lib,
  ...
}: {
  perSystem = {
    pkgs,
    self',
    inputs',
    ...
  }: let
    packageName = "aseprite";
  in {
    packages.${packageName} = let
      stdenv = pkgs.clangStdenv;
      skia-src = pkgs.fetchzip {
        url = "https://github.com/aseprite/skia/releases/download/m124-08a5439a6b/Skia-Linux-Release-x64.zip";
        hash = "sha256-4PEuQs9gnlH4uQyTuktwTlkffzZACh5ei7KpN1OAtZE=";
        stripRoot = false;
      };
      aseprite-src = pkgs.fetchzip {
        url = "https://github.com/aseprite/aseprite/releases/download/v1.3.17/Aseprite-v1.3.17-Source.zip";
        hash = "sha256-3Vago+3pHCU06+tM+y/mJ6yPT+puXF3XmFerGIeu8TU=";
        stripRoot = false;
      };
    in
      stdenv.mkDerivation {
        name = "aseprite";
        version = "1.3.17";
        src = "${aseprite-src}";
        meta.license = "unfree";
        nativeBuildInputs = with pkgs; [
          clang
          cmake
          unzip
          ninja
          libx11.dev
          libxcursor.dev
          libxi.dev
          libxi.out
          libxcb.dev
          libxrandr.dev
          libGL
          fontconfig
          libwebp
          freetype
          harfbuzz
          mesa
          libglvnd.dev
        ];

        packages = with pkgs; [
          libX11.dev
          libXcursor.dev
          libXi.dev
          libXi.out
          libglvnd.dev
          xorgproto.out
          mesa
          libGL
          fontconfig
          libwebp
          openssl.dev
          pkg-config
          freetype
          harfbuzz
        ];

        cmakeFlags = [
          ''-DCMAKE_BUILD_TYPE=RelWithDebInfo''
          ''-DCMAKE_EXE_LINKER_FLAGS:String="-stdlib=libstdc++"''
          ''-DLAF_BACKEND=skia''
          ''-DSKIA_DIR=${skia-src}/''
          ''-DSKIA_LIBRARY_DIR=${skia-src}/out/Release-x64''
          ''-DSKIA_LIBRARY=${skia-src}/out/Release-x64/libskia.a''
          ''-DWEBP_LIBRARIES=${pkgs.libwebp}/lib/libwebp.so''
          ''-DHARFBUZZ_LIBRARY=${pkgs.harfbuzz}/lib/libharfbuzz.so''
          ''-DFREETYPE_LIBRARY=${pkgs.freetype}/lib/libfreetype.so''
        ];
        installPhase = ''
          mkdir $out
          mkdir $out/bin
          mkdir $out/share
          mkdir $out/share/aseprite
          mkdir $out/share/applications
          mkdir $out/share/mime
          mkdir $out/share/mime/packages
          mv bin/aseprite $out/bin
          mv bin/* $out/share/aseprite
          cp ${./aseprite.desktop} $out/share/applications/
          cp ${./aseprite.xml} $out/share/mime/packages/
        '';
      };

    apps.${packageName} = {
      meta.description = "${packageName}";
      program = self'.packages.${packageName};
      type = "app";
    };
  };
}
