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
    packageName = "zsh";
  in {
    packages.${packageName} = let
      starship_config = builtins.readFile ./starship-config.toml;
      cowfile = pkgs.writeTextFile {
        name = "cat.cow";
        text = ''
          $the_cow = <<EOC;
                    $thoughts
                     $thoughts
                   /\\_/\\
             _____/ o o \\
            /~____  =-= /
           (______)__m_m)
          EOC
        '';
        destination = "/cat.cow";
      };
      zshrc_data = ''
        [ -f "$HOME/.zshenv" ] && source "$HOME/.zshenv";
        [ -f "$HOME/.zvars"  ] && source "$HOME/.zvars";

        export ZINIT_HOME="''${XDG_DATA_HOME:-''${HOME}/.cache/}/zinit/zinit.git"
        export MANPAGER="/bin/sh -c 'col -bx | bat -l man --style=plain --paging=always'"
        export MANROFFOPT="-c"
        export EDITOR=nvim
        export ZSH_AUTOSUGGEST_STRATEGY=(completion history)
        export HISTORY_SUBSTRING_SEARCH_PREFIXED=1;
        export HISTORY_SUBSTRING_SEARCH_ENSURE_UNIQUE=1;
        export HISTORY_SUBSTRING_SEARCH_HIGHLIGHT_FOUND=default;
        export HISTORY_SUBSTRING_SEARCH_HIGHLIGHT_NOT_FOUND=default;

        [ ! -d $ZINIT_HOME ] && mkdir -p "$(dirname $ZINIT_HOME)"
        [ ! -d $ZINIT_HOME/.git ] && git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME" --depth=1
        source "''${ZINIT_HOME}/zinit.zsh"

        [ -f /etc/zshenv ] && source /etc/zshenv

        mkdir -p "$HOME/.zfunc"
        fpath+="$HOME/.zfunc"
        path+="${pkgs.comma}/bin/"
        path+="${pkgs.zoxide}/bin/"
        path+="${pkgs.fzf}/bin/"
        path+="${pkgs.starship}/bin/"

        [ ! -f "$HOME/.zfunc/_rustup" ] && { rustup completions zsh rustup |> "$HOME/.zfunc/_rustup" }
        [ ! -f "$HOME/.zfunc/_cargo" ] && { rustup completions zsh cargo |> "$HOME/.zfunc/_cargo" }


        zinit ice wait lucid; zinit light Aloxaf/fzf-tab
        zinit ice wait lucid; zinit light nix-community/nix-zsh-completions
        zinit ice wait lucid; zinit light z-shell/F-Sy-H
        zinit ice wait lucid; zinit light zsh-users/zsh-autosuggestions
        zinit ice wait lucid; zinit light zsh-users/zsh-syntax-highlighting

        zinit ice wait lucid; zinit snippet OMZP::git
        zinit ice wait lucid as'completions'; zinit snippet OMZP::sudo
        zinit ice wait lucid as'completions'; zinit snippet OMZP::rust

        zinit load 'zsh-users/zsh-history-substring-search'
        zinit ice wait atload'_history_substring_search_config'

        bindkey '^[[A' history-substring-search-up
        bindkey '^[[B' history-substring-search-down

        bindkey '^[OA' history-substring-search-up
        bindkey '^[OB' history-substring-search-down

        bindkey '^[[1;5C' forward-word
        bindkey '^[[1;5D' backward-word
        bindkey '^[Oc' forward-word
        bindkey '^[Od' backward-word

        bindkey '^[[1;2D' beginning-of-line
        bindkey '^[[1;2C' end-of-line
        bindkey '^[[1;3D' beginning-of-line
        bindkey '^[[1;3C' end-of-line
        bindkey '^A' beginning-of-line
        bindkey '^E' end-of-line

        bindkey '^H' backward-kill-word


        bindkey -r '^['

        HISTSIZE=5000
        SAVEHIST=$HISTSIZE

        HISTFILE="$HOME/.zsh_history"
        mkdir -p "$(dirname "$HISTFILE")"
        HISTDUP=erase
        setopt SHARE_HISTORY
        setopt HIST_FCNTL_LOCK
        setopt HIST_IGNORE_SPACE
        setopt HIST_IGNORE_DUPS
        setopt HIST_IGNORE_ALL_DUPS
        unsetopt HIST_EXPIRE_DUPS_FIRST
        unsetopt EXTENDED_HISTORY

        zi for \
          atload"zicompinit; zicdreplay" \
          blockf \
          lucid \
          wait \
        zsh-users/zsh-completions

        zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
        zstyle ':completion:*' list-colors "''${(s.:.)LS_COLORS}"
        zstyle ':completion:*' menu no
        zstyle ':fzf-tab:complete:cd:*' fzf-preview '${lib.getExe pkgs.eza} -a --icons --color $realpath'
        zstyle ':fzf-tab:complete:__zoxide_z:*' fzf-preview '${lib.getExe pkgs.eza} -a --icons --color $realpath'

        if test -n "$KITTY_INSTALLATION_DIR"; then
          export KITTY_SHELL_INTEGRATION="enabled"
          autoload -Uz -- "$KITTY_INSTALLATION_DIR"/shell-integration/zsh/kitty-integration
          kitty-integration
          unfunction kitty-integration
        fi

        export STARSHIP_CONFIG="${pkgs.writeTextFile {
          name = "starship-config.toml";
          text = starship_config;
        }}"

        zmodload zsh/zpty

          ${lib.getExe pkgs.fortune}               \
        | ${lib.getExe pkgs.cowsay} -f "${cowfile}/cat.cow" \
        | ${lib.getExe pkgs.dotacat}


        alias -- 'cat'='${lib.getExe pkgs.bat} -p'
        alias -- 'ls'='${lib.getExe pkgs.eza} --icons -a'
        alias -- 'll'='${lib.getExe pkgs.eza} --icons -a -l'
        alias -- 'cdtemp'='cd "$(mktemp -d)"'


        preexec() {
          cmd=$1
          if [[ -n $cmd ]]; then
            print -Pn "\e]0;$title_prefix$cmd\a"
          fi
        }

        precmd() {
          dir=$(pwd | sed "s:$HOME:~:")
          print -Pn "\e]0;$(whoami)@$(hostname):$dir\a"
        }

        zinit ice wait lucid; zinit light olets/zsh-transient-prompt

        eval "$(${lib.getExe pkgs.starship} init zsh)"
        eval "$(${lib.getExe pkgs.zoxide} init zsh)"
        eval "$(${lib.getExe pkgs.direnv} hook zsh)"
        eval "$(${lib.getExe pkgs.fzf} --zsh)"

        TRANSIENT_PROMPT_PROMPT='$(${lib.getExe pkgs.starship} prompt --terminal-width="$COLUMNS" --keymap="${"$"}{KEYMAP:-}" --status="$STARSHIP_CMD_STATUS" --pipestatus="${"$"}{STARSHIP_PIPE_STATUS[*]}" --cmd-duration="${"$"}{STARSHIP_DURATION:-}" --jobs="$STARSHIP_JOBS_COUNT")'
        TRANSIENT_PROMPT_RPROMPT='$(${lib.getExe pkgs.starship} prompt --right --terminal-width="$COLUMNS" --keymap="${"$"}{KEYMAP:-}" --status="$STARSHIP_CMD_STATUS" --pipestatus="${"$"}{STARSHIP_PIPE_STATUS[*]}" --cmd-duration="${"$"}{STARSHIP_DURATION:-}" --jobs="$STARSHIP_JOBS_COUNT")'
        TRANSIENT_PROMPT_TRANSIENT_PROMPT='$(${lib.getExe pkgs.starship} module character)'

      '';
      zsh_config_file = pkgs.writeTextFile {
        name = ".zshrc";
        text = zshrc_data;
        destination = "/.zshrc";
      };
    in
      pkgs.writeShellApplication {
        name = "zsh";
        runtimeInputs = with pkgs; [fzf direnv zoxide starship];
        text = ''
          ZDOTDIR="${zsh_config_file}/" LANG=C.UTF-8 exec ${pkgs.zsh}/bin/zsh "$@"
        '';
        derivationArgs = {
          passthru.shellPath = "/bin/zsh";
        };
      };

    apps.${packageName} = {
      meta.description = "Custom ${packageName} package";
      program = self'.packages.${packageName};
      type = "app";
    };
  };
}
