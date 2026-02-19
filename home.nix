{ config, pkgs, ... }: {
  programs.home-manager.enable = true;
  nixpkgs.config.allowUnfree = true;

  home = {
    username = "anon";
    homeDirectory = "/home/anon";

    packages = with pkgs; [
      hello
    ];

    file = {
      # # Building this configuration will create a copy of 'dotfiles/screenrc' in
      # # the Nix store. Activating the configuration will then make '~/.screenrc' a
      # # symlink to the Nix store copy.
      # ".screenrc".source = dotfiles/screenrc;

      # # You can also set the file content immediately.
      # ".gradle/gradle.properties".text = ''
      #   org.gradle.console=verbose
      #   org.gradle.daemon.idletimeout=3600000
      # '';
    };

    sessionVariables = {
      EDITOR="nvim";
    };

    stateVersion = "25.11";
  };

  # systemd.user.sessionVariables = {
    # "POWERDEVIL_NO_DDCUTIL" = "1";
  # };

  xdg.userDirs = {
    enable = true;
    createDirectories = true;
    desktop = "${config.home.homeDirectory}/.xdg/desktop";
    documents = "${config.home.homeDirectory}/docs";
    download = "${config.home.homeDirectory}/dl";
    music = "${config.home.homeDirectory}/docs/music";
    pictures = "${config.home.homeDirectory}/docs/pictures";
    publicShare = "${config.home.homeDirectory}/.xdg/share";
    templates = "${config.home.homeDirectory}/.xdg/templates";
    videos = "${config.home.homeDirectory}/docs/videos";
  };
}
