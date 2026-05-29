{
  config,
  pkgs,
  ...
}: {
  environment.systemPackages = with pkgs; [
    btop
    vim
    git

    yazi
    lazygit

    docker
    cloudflared
    go
    gcc
    sqlite
    sqlite-web
  ];
}
