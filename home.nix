{ config
, pkgs
, lib
, ...
}:

let
  rustVersion = (pkgs.rustChannelOf { channel = "stable"; }).rust;
  rsPlatform = pkgs.makeRustPlatform {
    cargo = rustVersion;
    rustc = rustVersion;
  };
in
{
  home.packages = with pkgs; [
    astyle
	nodejs
	dotnet-sdk
    neovim-remote
	mono
	blender
	omnisharp-roslyn
	bitwarden-cli
    rustup
    neovim-nightly
 	python39Packages.jedi-language-server   
 	rust-analyzer
    clang-tools
    nodePackages.vscode-json-languageserver
    exa
    python3
    topgrade
    rsync
    fd
    niv
    bintools
    httpie
    sqlx-cli
    direnv
    codespell
    ripgrep
    file
    jq
    wget
    cargo-flamegraph
    linuxPackages.perf
    unzip
	docker
	docker-ls
	docker-gc
  tokei
  ];


  programs = {
    home-manager = {
      enable = true;
    };

    starship = {
      enable = true;
    };

    bat = {
      enable = true;
    };

    zoxide = {
      enable = true;
    };
  };


  home.file = {
    "bin" = {
      source = ./scripts;
      recursive = true;
    };
  };

  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "21.11";
}
