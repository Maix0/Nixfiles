{
  description = "A basic flake with a shell";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    rust-overlay.url = "github:oxalica/rust-overlay";
    cargo-workspace.url = "github:Maix0/cargo-ws-flake";
    cargo-semver-checks.url = "github:Maix0/cargo-semver-checks-flake";
  };
  outputs = {
    self,
    nixpkgs,
    flake-utils,
    rust-overlay,
    ...
  } @ inputs:
    flake-utils.lib.eachDefaultSystem (system: let
      pkgs = import nixpkgs {
        inherit system;
        overlays = [(import rust-overlay)];
      };
      packageIf = name: packageDef:
        if builtins.hasAttr name inputs
        then [(packageDef inputs.${name})]
        else [];
      buildRustToolchain = toolchainDef:
        if builtins.isString toolchainDef
        then let
          split = pkgs.lib.strings.splitString "/" toolchainDef;
          toolchainType =
            if (builtins.length split) > 3
            then throw "You can only specify a single version using `{type}/{version}/{profile}`"
            else if (builtins.length split) >= 1
            then builtins.elemAt split 0
            else throw "You must specify at least a toolchain version with this format `{type}/{version}/{profile}`";
          toolchainVersion =
            if (builtins.length split) > 3
            then throw "You can only specify a single version using `{type}/{version}/{profile}`"
            else if (builtins.length split) >= 2
            then builtins.elemAt split 1
            else "latest";
          toolchainProfile =
            if (builtins.length split) > 3
            then throw "You can only specify a single version using `{type}/{version}/{profile}`"
            else if (builtins.length split) >= 3
            then builtins.elemAt split 2
            else "default";
        in
          buildRustToolchain {
            toolchain = toolchainType;
            version = toolchainVersion;
            profile = toolchainProfile;
          }
        else if builtins.isAttrs toolchainDef
        then
          if toolchainDef.toolchain == "stable"
          then pkgs.rust-bin.stable.${toolchainDef.version}.${toolchainDef.profile}.override (builtins.removeAttrs toolchainDef ["toolchain" "version" "profile"])
          else if toolchainDef.toolchain == "beta"
          then pkgs.rust-bin.beta.${toolchainDef.version}.${toolchainDef.profile}.override (builtins.removeAttrs toolchainDef ["toolchain" "version" "profile"])
          else if toolchainDef.toolchain == "nightly"
          then
            if toolchainDef.version == "latest"
            then pkgs.rust-bin.selectLatestNightlyWith (toolchain: toolchain.${toolchainDef.profile}.override (builtins.removeAttrs toolchainDef ["toolchain" "version" "profile"]))
            else pkgs.rust-bin.nightly.${toolchainDef.version}.${toolchainDef.profile}.override (builtins.removeAttrs toolchainDef ["toolchain" "version" "profile"])
          else throw "toolchain version isn't valid (not 'stable' or 'beta' or 'nightly')"
        else throw "toolchainDef isn't a string or an attr describing the toolchain";
    in {
      devShell = let
        rust_dev = buildRustToolchain "stable/latest/minimal";
        # {
        #   extensions = [];
        #   targets = ["x86_64-unknown-linux-gnu"];
        # };
      in
        pkgs.mkShell {
          packages = with pkgs;
            [
              rust_dev
              mold
            ]
            ++ (packageIf "cargo-semver-checks" (p: p.packages.${system}.default))
            ++ (packageIf "cargo-workspace" (p: p.packages.${system}.default));

          shellHook = ''
            export RUST_STD="${rust_dev}/share/doc/rust/html/std/index.html"

            if [ -z $CARGO_TARGET_DIR ] then
              : "''${XDG_CACHE_HOME:="''$HOME/.cache"}"
              local hash path
              hash="$(sha1sum - <<< "$PWD" | head -c40)"
              path="''${PWD//[^a-zA-Z0-9]/}"
              export CARGO_TARGET_DIR="''${XDG_CACHE_HOME}/rust-targets/$hash-$path"
            fi
          '';
        };
    });
}
