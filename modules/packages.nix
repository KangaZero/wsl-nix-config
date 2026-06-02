{ pkgs, ... }:

{
  home.packages = with pkgs; [
    git
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
    # Font
    nerd-fonts.jetbrains-mono
    # Package managers
    nodejs_26
    pnpm
    rustup
    python3
    mise
    uv
    just
    # The forbidden fruit
    claude-code
  ];
}
