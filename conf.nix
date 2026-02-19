{ config, pkgs, inputs, ... }: {
  imports = [ ./hardware.nix ];

  boot = {
    # plymouth = {
      # enable = true;
      # theme = "breeze";
      # themePackages = [ pkgs.kdePackages.breeze-plymouth ];
    # };
    loader = {
      timeout = 0;
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
  };

  networking = {
    hostName = "nixon";
    networkmanager.enable = true;
  };


  time.timeZone = "America/New_York";
  i18n.defaultLocale = "en_US.UTF-8";

  security.rtkit.enable = true;

  # systemd.user.services.plasma-powerdevil = {
    # unitConfig = {
      # Description = "Powerdevil";
      # PartOf = "graphical-session.target";
      # After = "plasma-core.target";
    # };

    # serviceConfig = {
      # ExecStart = pkgs.powerdevil/libexec/org_kde_powerdevil;
      # Type = "dbus";
      # BusName = "org.kde.Solid.PowerManagement";
      # TimeoutStopSec = "5sec";
      # Slice = "background.slice";
      # Restart = "on-failure";
      # Environment = "POWERDEVIL_NO_DDCUTIL = 1";
    # };
  # };

  services = {
    desktopManager.plasma6.enable = true;
    kanata = {
      enable = true;
      keyboards.platform-i8042-serio-0-event-kbd.configFile = ./conf/kanata.kbd;
    };
    pipewire = {
      enable = true;
      pulse.enable = true;
      alsa = {
        enable = true;
        support32Bit = true;
      };
    };
    getty = {
      autologinOnce = true;
      autologinUser = "anon";
    };
    tailscale.enable = true;
    fprintd.enable = true;
  };

  programs = {
    fish = {
      enable = true;
      interactiveShellInit = "set fish_greeting";
      loginShellInit = ''
        if test -z "$WAYLAND_DISPLAY" -a "$XDG_VTNR" -eq 1
          exec startplasma-wayland
        end
      '';
      shellAbbrs = {
        vi = "nvim";
        svi = "sudo -E nvim";
        "vi.n" = "nvim ~/.nix";
        rebuild = "nh os switch ~/.nix";
      };
    };
    thunderbird.enable = true;
    # niri.enable = true;
  };

  nixpkgs.config.allowUnfree = true;
  environment = {
    plasma6.excludePackages = with pkgs.kdePackages; [
      kate
      elisa
      gwenview
      okular
      discover
      # khelpcenter
      # kinfocenter
    ];
    systemPackages = with pkgs; [
      git
      nh
      neovim
      foot
      signal-desktop
      zed-editor
      (librewolf.override {cfg.enablePlasmaBrowserIntegration= true; })
      obsidian
      vesktop
      spotify
      libreoffice
      krita
      libqalculate
      quickshell
      fuzzel
      imv
      yazi
      mpv
      bat
      eza
      ffmpeg
      imagemagick
      ungoogled-chromium
      kdePackages.yakuake
      freetube
      easyeffects
    ];
  };

  fonts.packages = with pkgs; [
    nerd-fonts.iosevka
    nerd-fonts.profont
  ];

  users.users.anon = {
    isNormalUser = true;
    shell = pkgs.fish;
    description = "anon";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [
    ];
  };

  home-manager = {
    extraSpecialArgs = {inherit inputs;};
    users.anon = import ./home.nix;
  };

  system.stateVersion = "25.11";
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
}
