{
  config,
  pkgs,
  ...
}: {
  programs.bash.promptInit = ''export PS1=" \[\e[92m\]nix \[\e[96m\]❯❯\[\e[0m\] " '';
  environment.shellAliases = {
    cn = "sudo vim /etc/nixos/configuration.nix";
    rb = "sudo nixos-rebuild switch";
    rbw = "/srv/cameronwilcox/deploy.sh";
    vdb = "sqlite3 -column -header data/camcam.db 'SELECT * FROM entries;'";
  };
  security.sudo.extraRules = [
    {
      users = ["undonecoffee"];
      commands = [
        {
          command = "/run/current-system/sw/bin/systemctl restart camcam";
          options = ["NOPASSWD"];
        }
      ];
    }
  ];
}
