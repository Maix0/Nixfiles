{
  pkgs,
  myPkgs,
  ...
}: {
  home.packages = with pkgs; [
    bat
    bat-extras.prettybat
    bitwarden-cli
    bottom
    comma
    fastmod
    fd
    file
    gef
    gnumake
    htop
    ipmitool
    jq
    ltrace
    man-pages
    man-pages-posix
    myPkgs.nvimMaix
    myPkgs.zshMaix
    nix-init
    nix-output-monitor
    nixpkgs-fmt
    nixpkgs-review
    oscclip
    pandoc
    ripgrep
    rsync
    socat
    tokei
    tree
    unzip
    wget
    zk

    # Useful for pandoc to latex
    (texlive.combine {
      inherit
        (texlive)
        scheme-medium
        fncychap
        wrapfig
        capt-of
        framed
        upquote
        needspace
        tabulary
        varwidth
        titlesec
        ;
    })
  ];
}
