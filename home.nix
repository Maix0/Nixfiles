{ config, pkgs, lib, ... }:

let
  rustVersion = (pkgs.rustChannelOf { channel = "stable"; }).rust;
  rsPlatform = pkgs.makeRustPlatform {
    cargo = rustVersion;
    rustc = rustVersion;
  };
  localinfo = import ./localinfo.nix;
  pkgCratesIO = { name, version, hash }: rsPlatform.buildRustPackage {
    pname = name;
    version = version;
    src = fetchTarball "https://static.crates.io/crates/${name}/${name}-${version}.crate";
    cargoSha256 = hash;
  };
in
{
  imports = [
    ./graphical.nix
  ];
  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home.username = localinfo.username;
  home.homeDirectory = localinfo.homeDir;

  home.sessionVariables = {
    EDITOR = "nvim";
    RUSTC_WRAPPER = "${pkgs.sccache}/bin/sccache";
  };

  home.packages = with pkgs; [
    bitwarden-cli
    rustup
    neovim-nightly
    rust-analyzer
    clang-tools
    nodePackages.vscode-json-languageserver
    nodePackages.bash-language-server
    nixpkgs-fmt
    (import (builtins.fetchTarball {
      url = https://github.com/nix-community/rnix-lsp/archive/master.tar.gz;
    }))
    exa
    python3
    topgrade
    wl-clipboard
    (pkgCratesIO {
      name = "dotacat";
      version = "0.2.0";
      hash = "1lnmw0c7m40ysbar8bk6r2jh32w6613457r5wgp418pgy2300kvn";
    })
    cargo-edit
    rsync
    fd
    niv
    bintools
    httpie
    sqlx-cli
    direnv
    (rsPlatform.buildRustPackage rec {
      pname = "stylua";
      version = "0.11.0";
      src = fetchFromGitHub {
        owner = "johnnymorganz";
        repo = "stylua";
        rev = "0caa9a2";
        sha256 = "1r6jr2ghha6wklm2bwrixmq0r4h5vrvaryrz11q6hpfwpicpdnn1";
      };
      cargoSha256 = "0v2154qd4m8yqpv0v4ikhymd693p0bbf8vxf7h5bzb4d9vaxxb6m";
    })
	codespell
	shellcheck
  ];

  services = {
    syncthing = {
      enable = true;
      tray = {
        enable = true;
      };
    };
  };

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

    git = {
      enable = true;
      delta = {
        enable = true;
      };
      userName = "Quentin Boyer";
      userEmail = localinfo.email;
    };

    zoxide = {
      enable = true;
    };

    zsh = {
      enable = true;
      enableCompletion = true;
      oh-my-zsh = {
        enable = true;
        plugins = [ "git" "wd" "rust" ];
      };
      plugins = [
        {
          name = "fast-syntax-highlighting";
          file = "fast-syntax-highlighting.plugin.zsh";
          src = pkgs.fetchFromGitHub {
            owner = "zdharma";
            repo = "fast-syntax-highlighting";
            rev = "817916dfa907d179f0d46d8de355e883cf67bd97";
            sha256 = "0m102makrfz1ibxq8rx77nngjyhdqrm8hsrr9342zzhq1nf4wxxc";
          };
        }
        {
          name = "zsh-nix-shell";
          file = "nix-shell.plugin.zsh";
          src = pkgs.fetchFromGitHub {
            owner = "chisui";
            repo = "zsh-nix-shell";
            rev = "v0.4.0";
            sha256 = "1gfyrgn23zpwv1vj37gf28hf5z0ka0w5qm6286a7qixwv7ijnrx9";
          };
        }
        {
          name = "nix-zsh-completions";
          file = "nix-zsh-completions.plugin.zsh ";
          src = pkgs.fetchFromGitHub {
            owner = "spwhitt";
            repo = "nix-zsh-completions";
            rev = "0.4.4";
            sha256 = "1n9whlys95k4wc57cnz3n07p7zpkv796qkmn68a50ygkx6h3afqf";
          };
        }
      ];
      initExtra =
        ''
           export PATH="$PATH:${localinfo.homeDir}/bin"
           source ~/.p10k.zsh
           source ~/.powerlevel10k/powerlevel10k.zsh-theme
		   eval "$(${pkgs.direnv}/bin/direnv hook zsh)"
           if [ -f "$HOME/.zvars" ]; then
               source "$HOME/.zvars"
           fi
            ${pkgs.fortune}/bin/fortune \
            	| ${pkgs.cowsay}/bin/cowsay \
            	| dotacat
        '';
      shellAliases = {
        cat = "${pkgs.bat}/bin/bat -p";
        ls = "${pkgs.exa}/bin/exa --icons";
        screenRegion = "${pkgs.slurp}/bin/slurp | ${pkgs.grim}/bin/grim -g - ";
        py3 = "nix-shell -p python3 python3.pkgs.matplotlib --run python3";
        ssh = "kitty +kitten ssh";
        ns = "nix-shell";
      };
    };
  };
  home.file = {
    ".config/nvim" = {
      source = ./nvim;
      recursive = true;
    };
    ".powerlevel10k" = {
      source = pkgs.fetchFromGitHub {
        owner = "romkatv";
        repo = "powerlevel10k";
        rev = "v1.15.0";
        sha256 = "1b3j2riainx3zz4irww72z0pb8l8ymnh1903zpsy5wmjgb0wkcwq";
      };
    };
    ".zprofile".source = ./zprofile;
    ".p10k.zsh".source = ./p10k.zsh;
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
