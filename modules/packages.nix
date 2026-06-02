{ pkgs, ... }:

{
  home.packages = with pkgs; [
    fzf
    zoxide
    ripgrep
    bat
    eza
    curl
    wget
    openssh
    tldr
    ffmpeg-full
    unzip
    fd
    jq
    btop
    # Quality of life tools
    yazi
    zellij
    lazygit
    # Font - note this does not do anything as we are in WSL, so need to unfortunately imperatively download and set the font on Windows
    nerd-fonts.jetbrains-mono
    # Package managers
    nodejs_26
    pnpm
    rustup
    python3
    mise
    uv
    just
    azure-cli
    # The forbidden fruit
    claude-code
  ];
}
