{ config, lib, pkgs, ... }:

{
  # ponytail: Generated hardware stays separate; add this import after install.
  # imports = [ ./hardware-configuration.nix ];

  networking = {
    hostName = "steamos";
    networkmanager.enable = true;
  };

  boot = {
    tmp.cleanOnBoot = true;
    consoleLogLevel = 3;
    kernelParams = [ "quiet" ];
    plymouth.enable = true;
    loader = {
      timeout = 0; # Hold Space during boot to show systemd-boot menu.
      systemd-boot = {
        enable = true;
        configurationLimit = 10;
      };
      efi.canTouchEfiVariables = true;
    };
  };

  hardware = {
    cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
    bluetooth = {
      enable = true;
      powerOnBoot = true;
    };
  };
  services.xserver.videoDrivers = [ "amdgpu" ];

  jovian = {
    hardware.has.amd.gpu = true;
    steam = {
      enable = true;
      autoStart = true;
      user = "gamer";
      desktopSession = "plasma";
    };
  };

  services = {
    desktopManager.plasma6.enable = true;
    pipewire = {
      enable = true;
      alsa.enable = true;
      pulse.enable = true;
    };
    power-profiles-daemon.enable = true;
    fstrim.enable = true;
  };
  security.rtkit.enable = true;

  environment.systemPackages = [
    pkgs.git
    pkgs.chromium
  ];

  # ponytail: systemd auto-detects the motherboard watchdog; raise 30s if it
  # causes false resets on this hardware.
  systemd.settings.Manager = {
    RuntimeWatchdogSec = "30s";
    RebootWatchdogSec = "10min";
  };

  users.users.gamer = {
    isNormalUser = true;
    description = "Gaming user";
    extraGroups = [
      "networkmanager"
      "wheel"
    ];
  };

  time.timeZone = "Asia/Jakarta";
  i18n.defaultLocale = "en_US.UTF-8";

  nixpkgs.config.allowUnfree = true; # Steam and Jovian hardware theme.

  nix = {
    settings.experimental-features = [
      "nix-command"
      "flakes"
    ];
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 30d";
    };
  };

  # Host stays pinned by flake.lock; Steam client and games update independently.
  system.stateVersion = "25.11";
}
