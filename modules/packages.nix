{ pkgs, ... }:

{
  home.packages = with pkgs; [
    writeShellApplication
    {
      name = "ns";
      runtimeInputs = with pkgs; [
        fzf
        nix-search-tv
      ];
      text = builtins.readFile "${pkgs.nix-search-tv.src}/nixpkgs.sh";
    }
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
    # Font - Used in i3 and Kitty
    nerd-fonts.jetbrains-mono
    # Package managers
    nodejs_26
    pnpm
    rustup
    python3
    mise
    uv
    just
    (azure-cli.withExtensions [ azure-cli-extensions.azure-devops ])
    # The forbidden fruit
    claude-code
    # Browser: firefox-devedition is now managed declaratively in ./firefox.nix
  ];
}
