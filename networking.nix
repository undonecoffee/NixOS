{
  config,
  pkgs,
  ...
}: {
  systemd.services.camcam = {
    description = "camcam time tracker";
    wantedBy = ["multi-user.target"];
    after = ["network.target"];
    serviceConfig = {
      ExecStart = "/srv/cameronwilcox/camcam";
      WorkingDirectory = "/srv/cameronwilcox";
      Restart = "always";
    };
  };

systemd.services.sqlite-web = {
  description = "sqlite_web web interface for camcam.db";
  after = [ "network.target" ];
  wantedBy = [ "multi-user.target" ];
  
  serviceConfig = {
    Type = "simple";
    ExecStart = "${pkgs.sqlite-web}/bin/sqlite_web --host 0.0.0.0 --port 8081 /srv/cameronwilcox/data/camcam.db";
    Restart = "always";
    RestartSec = "5s";
    # Optional: Run as a non-root user for security, just ensure they have read/write access to the DB file and its directory
    User = "undonecoffee"; 
  };
};

  systemd.services.cloudflared = {
    description = "main";
    wantedBy = ["multi-user.target"];
    after = ["network.target"];
    serviceConfig = {
      ExecStart = "${pkgs.cloudflared}/bin/cloudflared tunnel --no-autoupdate run --token eyJhIjoiMDBjZGJkY2IxYjU3MTBiMjY3YmZiMDk1NWQ1MWFkNDgiLCJ0IjoiYzYxMjU2MjQtNWViNC00NWQyLTliM2ItNzg2MWRmMzhkYWM1IiwicyI6Ik5qWTFaV1l4TWpjdE1qQmlaUzAwTTJNeUxUbGtOR010TkRoak0yRmhaVEl4TURGaCJ9";
      Restart = "always";
    };
  };

  services = {
    audiobookshelf = {
      enable = true;
      host = "0.0.0.0";
      port = 8010;
    };
    # jellyfin.enable = true;
    # immich.enable = true;
  };
  networking = {
    networkmanager.enable = true;

    firewall.allowedTCPPorts = [22 26 8096 8010 2283 5001 8081]; # 8096 jellyfin   2283 immcnhfhdis
    # networking.firewall.enable = false;

    useDHCP = false; # Disable global DHCP if possible
    interfaces.enp3s0f3u2c2.useDHCP = false;
    interfaces.enp3s0f3u2c2.ipv4.addresses = [
      {
        address = "192.168.1.67";
        prefixLength = 24;
      }
    ];
    defaultGateway = "192.168.1.1";
    nameservers = ["1.1.1.1" "8.8.8.8"];
  };
}
