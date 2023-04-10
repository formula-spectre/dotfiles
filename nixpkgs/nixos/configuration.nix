# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:
let 
  kmonad = import ./kmonad.nix;
in
{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      <home-manager/nixos>
    ];
  hardware.trackpoint = {
    enable = true;
    sensitivity = 255;
    emulateWheel = true;
  };
  nix = {
    autoOptimiseStore = true;
    extraOptions = ''experimental-features = nix-command flakes'';
    settings = {
      max-jobs = 4;
    };
  };
  environment.pathsToLink = [ "/share/zsh" "/usr/bin"];
  virtualisation = {
    podman = {
      enable = true;
      extraPackages = [ pkgs.zfs ];
    };
    docker = {
      enable = true;
    };
  };

  # Use the systemd-boot EFI boot loader.
  systemd = {
    services = {
      kmonad-x230 = {
        enable = true;
        description = "kmonad daemon for the x230 keyboard";
        serviceConfig = {
          Restart = "always";
          RestartSec = 3;
          ExecStart = "${kmonad}/bin/kmonad /home/formula/.config/kmonad/kmonad-x230.kbd";
        };
        wantedBy = [ "default.target"];
      };
      kmonad-kritakb = {
        enable = true;
        description = "kmonad daemon to reprogram the KB_Gaming_KB";
        serviceConfig = {
          Restart = "always";
          RestartSec = 3;
          ExecStart = "${kmonad}/bin/kmonad /home/formula/.config/kmonad/kb-half-krita.kbd";
        };
        wantedBy = [ "default.target"];
      };      
    };
    user.services = {
      shepherd = {
#        enable=true;
        description = "custom shepherd unit";
        serviceConfig = {
          Enviroment="EMACSDIR=~/.config/emacs DOOMDIR=~/.config/doom.d";
          Type = "forking";
          ExecStart = "${pkgs.gnu-shepherd}/bin/shepherd";
          ExecStop = "herd stop root";
          Restart = "on-failure";
        };
        wantedBy = ["default.target"];
      };
    };
  };

  boot = {
    kernelPackages = pkgs.linuxPackages_xanmod;
    loader = {
      systemd-boot.enable = true;
      efi = {
        canTouchEfiVariables = true;
      };
    };
    supportedFilesystems = [ "zfs"  "btrfs"];
    zfs = {
      devNodes = "/dev/";
    };
    kernelParams = [ "thinkpad_acpi.fan_control=1" "thinkpad_acpi.experimental=1" "nowatchdog" "zfs.zfs_arc_max=4294967296"];
  };

  networking = {
    wireless = {
      iwd = {
        enable = true;
      };
    };
  useDHCP = true;
  hostId = "f09049e9";
  hostName = "kabuto-nixos";
  };
  
  nixpkgs = {
    config = {
      allowUnfree = true;
    };
  };
  # Set your time zone.
  time.timeZone = "Europe/Rome";

  fonts.fonts = with pkgs; [
    (nerdfonts.override { fonts = [ "Iosevka" ]; })
  ];

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    font = "Iosevka";
    useXkbConfig = true; # use xkbOptions in tty.
  };
  security = {
    rtkit.enable = true;
  };
  # Enable the X11 windowing system.
  services = {
    logind.extraConfig = ''
                         HandlePowerKey=ignore
                         '';
    xserver = {
      enable = true;
      wacom.enable = true;
      windowManager = {
        xmonad = {
          enable = true;
          enableContribAndExtras = true;
        };
      };
      displayManager.startx.enable = true;
      layout = "it";
      xkbVariant = "us";
      xkbOptions = "ctrl:nocaps"; # map caps lock to ctrl      
    };
    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
    };
    udev = {
      extraRules = ''
        ACTION=="add|change", KERNEL=="sd[a-z]*[0-9]*|mmcblk[0-9]*p[0-9]*|nvme[0-9]*n[0-9]*p[0-9]*", ENV{ID_FS_TYPE}=="zfs_member", ATTR{../queue/scheduler}="none"
        KERNEL=="uinput", MODE="0660", GROUP="uinput", OPTIONS+="static_node=uinput"
                      '';
    };
    zfs.autoScrub.enable = true;
    thinkfan = {
      enable = true;
      smartSupport = true;
      sensors = [
        {
          type = "tpacpi";
          query = "/proc/acpi/ibm/thermal";
        }
      ];
      fans = [
        {
          type = "tpacpi";
          query = "/proc/acpi/ibm/fan";
        }
      ];
      levels = [
        [0  0   41]
        [1  38  51]
        [2  45  56]
        [3  51  61]
        [4  55  64]
        [5  60  66]
        [6  63  68]
        [7  65  74]
        [127 70 3276]
      ];
      extraArgs = [ "-s5" ];
      
    };
  };

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable sound.
  sound.enable = true;
  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.formula = {
    isNormalUser = true;
    home = "/home/formula";
    extraGroups = [ "wheel" "audio" "video" "tty" "input" "uinput" "adbusers" "docker"]; 
    packages = with pkgs; [
      thunderbird
      birdtray
      termonad
      alacritty
      fzf
      lsd
      git
      brave
      dmenu
      rofi
      ripgrep
      fd
      bat
      sx
      s6-rc
      s6
      execline
      s6-man-pages
      redshift
      tdesktop
      trayer
      materia-theme
      procs
      neofetch
      flameshot
      maim
      spectacle
      feh
      haskellPackages.greenclip
      home-manager
      krita
      dunst
    ];
    shell = pkgs.zsh;
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    (retroarch.override {
      cores = [
        libretro.parallel-n64
      ];
    })
    libretro.parallel-n64
    vim #emacs
    wget
    w3m
    libnotify
    binutils
    gnumake
    clang
    xorg.xorgserver
    xorg.xf86inputevdev
    xorg.xf86inputlibinput
    xorg.xf86videointel
    xclip
    haskellPackages.xmonad
    haskellPackages.xmonad-contrib
    haskellPackages.xmonad-extras
    ghc
    kmonad
    gnu-shepherd
  ];
  programs = {
    slock.enable = true;
    light.enable = true;
    adb.enable = true;
    ssh.enableAskPassword = false;
  };
  

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  # system.copySystemConfiguration = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "22.05"; # Did you read the comment?
}

