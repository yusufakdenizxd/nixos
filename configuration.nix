# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{
  config,
  lib,
  pkgs,
  ...
}:

{
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
  ];

  boot.loader = {
    timeout = 0;
    systemd-boot = {
      enable = true;
      configurationLimit = 5;
    };
    efi.canTouchEfiVariables = true;
  };
  boot.kernelParams = [ "i915.enable_psr=0" ];

  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 7d";
  };

  services.gvfs.enable = true;
  services.gnome.tinysparql.enable = true;
  services.gnome.localsearch.enable = true;

  services.displayManager.sddm = {
    enable = true;
    wayland.enable = true;
  };
  services.flatpak.enable = true;

  services.displayManager.defaultSession = "sway";

  networking.networkmanager.enable = true;
  hardware.enableRedistributableFirmware = true;

  time.timeZone = "Europe/Berlin";

  hardware.sensor.iio.enable = true;
  services.libinput.enable = true;
  users.users.akdeniz = {
    isNormalUser = true;
    extraGroups = [
      "wheel"
      "networkmanager"
      "video"
      "input"
    ];
    packages = with pkgs; [
      tree
    ];
  };

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  users.defaultUserShell = pkgs.nushell;

  system.stateVersion = "26.05";

  hardware.graphics = {
    enable = true;
    extraPackages = with pkgs; [
      intel-media-driver
      libva-vdpau-driver
      libvdpau-va-gl
    ];
  };

  programs.sway = {
    enable = true;
    wrapperFeatures.gtk = true;
    extraPackages = with pkgs; [
      wmenu
      brightnessctl
      wireplumber
    ];
  };

  programs.nh = {
    enable = true;
    clean.enable = true;
    clean.extraArgs = "--keep-since 7d --keep 3";
    flake = "/home/akdeniz/dev/nixos";
  };

  services.power-profiles-daemon.enable = false;
  services.thermald.enable = true;

  services.tlp = {
    enable = true;
    settings = {
      CPU_SCALING_GOVERNOR_ON_AC = "powersave";
      CPU_SCALING_GOVERNOR_ON_BAT = "powersave";

      CPU_ENERGY_PERF_POLICY_ON_AC = "balance_performance";
      CPU_ENERGY_PERF_POLICY_ON_BAT = "balance_power";

      CPU_BOOST_ON_AC = 1;
      CPU_BOOST_ON_BAT = 1;

      START_CHARGE_THRESH_BAT0 = 75;
      STOP_CHARGE_THRESH_BAT0 = 80;
    };
  };

  systemd.services.fix-coil-whine = {
    description = "Disable C8-C10 idle states to eliminate VRM coil whine";
    wantedBy = [
      "multi-user.target"
      "post-resume.target"
    ];
    after = [
      "multi-user.target"
      "post-resume.target"
    ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
      ExecStart = "${pkgs.linuxPackages.cpupower}/bin/cpupower idle-set -D 6";
    };
  };

  zramSwap = {
    enable = true;
    memoryPercent = 50;
  };

  services.logind.settings.Login.HandleLidSwitch = "suspend";

  xdg.portal = {
    enable = true;
    wlr.enable = true;
  };

  security.rtkit.enable = true;

  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
    settings = {
      General = {
        ControllerMode = "bredr";
        FastConnectable = true;
      };
    };
  };

  services.pipewire = {
    enable = true;
    alsa.enable = true;
    pulse.enable = true;

    wireplumber.extraConfig."51-bluetooth-q30" = {
      "monitor.bluez.properties" = {
        "bluez5.enable-sbc-xq" = true;
        "bluez5.enable-msbc" = true;
        "bluez5.enable-hw-volume" = true;
        "bluez5.codecs" = [
          "aac"
          "sbc_xq"
          "sbc"
        ];
        "bluez5.roles" = [
          "a2dp_sink"
          "a2dp_source"
          "hfp_hf"
          "hfp_ag"
        ];
      };
      "monitor.bluez.rules" = [
        {
          matches = [
            { "device.name" = "~bluez_card.*"; }
          ];
          actions = {
            update-props = {
              "bluez5.auto-connect" = [ "a2dp_sink" ];
              "bluez5.hw-volume" = [ "a2dp_sink" ];
              "device.profile" = "a2dp-sink";
            };
          };
        }
      ];
      "wireplumber.settings" = {
        "bluetooth.autoswitch-to-headset-profile" = false;
      };
    };
  };

  programs.neovim = {
    enable = true;
    defaultEditor = true;
  };

  environment.systemPackages = with pkgs; [
    ghostty
    nushell

    (brave.override {
      commandLineArgs = [
        "--ozone-platform=wayland"
        "--enable-features=VaapiVideoDecodeLinuxGL,VaapiVideoDecoder,UseOzonePlatform"
        "--ignore-gpu-blocklist"
        "--enable-gpu-rasterization"
        "--enable-zero-copy"
      ];
    })
  ];

  fonts.fontconfig.enable = true;
  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
    nerd-fonts.caskaydia-cove
  ];

  home-manager.useGlobalPkgs = true;
  nixpkgs.config.allowUnfree = true;

  programs.dconf.enable = true;
  environment.variables = {
    NH_FLAKE = "/home/akdeniz/dev/nixos";
    NH_HOME_FLAKE = "/home/akdeniz/dev/nixos";
  };
}
