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
  }: {
    packages.pcb2gcode = inputs'.nixpkgs-stable.legacyPackages.pcb2gcode;
    packages.pcb2gcode-gui = pkgs.stdenv.mkDerivation (finalAttrs: {
      pname = "pcb2gcode-gui";
      version = "2.5.1";

      src = pkgs.fetchFromGitHub {
        owner = "pcb2gcode";
        repo = "pcb2gcodeGUI";
        hash = "sha256-Up+Vx3H5m3t9iyn9liP5IwVyWJxOYd3dByLGajML7rs=";
        rev = "cffcf1a2ac2360ca8b0cf2cc0298d237cd5dde5d";
      };

      nativeBuildInputs = with pkgs.qt6Packages; [
        qmake
        wrapQtAppsHook
        pkgs.makeWrapper
      ];

      buildInputs = with pkgs.qt6Packages; [
        qtbase
        qtsvg
      ];
      postPatchNO = ''
        echo "QT += svgwidgets" >> pcb2gcodeGUI.pro
        substituteInPlace mainwindow.cpp \
          --replace-fail \
          'QStandardPaths::DataLocation' \
          'QStandardPaths::AppDataLocation'

        # Replace removed QWheelEvent::orientation()
        substituteInPlace graphics_view_zoom.cpp \
          --replace-fail \
          'wheel_event->orientation() == Qt::Vertical' \
          'wheel_event->angleDelta().y() != 0'
      '';

      configurePhase = ''
        runHook preConfigure
        qmake PREFIX=$out pcb2gcodeGUI.pro
        runHook postConfigure
      '';

      postInstall = ''
        wrapProgram $out/bin/pcb2gcodeGUI \
          --suffix PATH : ${lib.makeBinPath [self'.packages.pcb2gcode]}
      '';

      meta = {
        description = "Qt GUI for pcb2gcode";
        homepage = "https://github.com/pcb2gcode/pcb2gcodeGUI";
        license = lib.licenses.gpl3Plus;
        platforms = lib.platforms.linux;
        mainProgram = "pcb2gcodeGUI";
      };
    });

    apps.pcb2gcode-gui = {
      meta.description = "pcb2gcode-gui";
      program = lib.getExe self'.packages.pcb2gcode-gui;
      type = "app";
    };
    apps.pcb2gcode = {
      meta.description = "pcb2gcode";
      program = lib.getExe self'.packages.pcb2gcode;
      type = "app";
    };
  };
}
