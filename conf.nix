{ config, pkgs, inputs, ... }: {
  imports = [ ./hardware.nix ];

  boot = {
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

  services = {
    desktopManager.plasma6.enable = true;
    kanata = {
      enable = true;
      keyboards.platform-i8042-serio-0-event-kbd.configFile = ./conf/kanata.kbd;
    };
    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      #jack.enable = true;
    };
    getty = {
      autologinUser = "anon";
      autologinOnce = true;
    };
    tailscale.enable = true;
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
    niri.enable = true;
    thunderbird.enable = true;
  };

  nixpkgs.config.allowUnfree = true;
  environment = {
    plasma6.excludePackages = with pkgs.kdePackages; [
      kate
      elisa
      gwenview
      okular
      khelpcenter
      kinfocenter
    ];
    systemPackages = with pkgs; [
      git
      nh
      neovim
      foot
      signal-desktop
      zed-editor
      librewolf
      obsidian
      vesktop
      spotify
      libreoffice
      krita
      libqalculate
      quickshell
      fuzzel
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
