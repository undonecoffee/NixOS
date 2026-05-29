{
  config,
  pkgs,
  ...
}: {
  imports = [./hardware-configuration.nix ./apps.nix ./config.nix ./networking.nix];

  services.logind.settings.Login.HandleLidSwitch = "ignore";
  services.logind.settings.Login.HandleLidSwitchExternalPower = "ignore";

  services.openssh.enable = true;
  services.openssh.settings.PasswordAuthentication = true;
  services.gpm.enable = true;  # Mouse

  boot.supportedFilesystems = ["exfat"];

  fileSystems."/mnt/media" = {
    device = "/dev/disk/by-uuid/2A06-F1E7";
    fsType = "exfat";
    options = ["nofail" "uid=1000" "gid=100" "umask=000"];
  };

  nixpkgs.config.allowUnfree = true;

  systemd.services.clean-macos-junk = {
    description = "Delete macOS ._* files every 5 minutes";
    serviceConfig = {
      Type = "oneshot";
      ExecStart = "${pkgs.findutils}/bin/find /home /etc/nixos -name '._*' -delete";
    };
  };

  systemd.timers.clean-macos-junk = {
    wantedBy = ["timers.target"];
    timerConfig = {
      OnBootSec = "0s";
      OnUnitActiveSec = "5m";
    };
  };

  #-------------------- NIX THINGS --------------------

  documentation.enable = false;
  documentation.nixos.enable = false;
  programs.ccache.enable = true;

  networking.networkmanager.enable = true; # Keep true if you use it, but...

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  networking.hostName = "nixos"; # Define your hostname.
  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  users.users.undonecoffee = {
    isNormalUser = true;
    extraGroups = ["networkmanager" "wheel"];
  };
  system.stateVersion = "25.11";
  time.timeZone = "America/Matamoros";
  i18n.defaultLocale = "en_US.UTF-8";
}
