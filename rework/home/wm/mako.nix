{...}: {
  mako = {
    settings = {
      defaultTimeout = builtins.toString 7000;
      enable = true;
      font = "hack nerd font 10";
      margin = "20,20,5,5";
      output = "eDP-1";
    };
  };
}
