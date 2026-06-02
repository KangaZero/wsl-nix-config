_:

{
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    # Lets neovim use the default ~/.config/nvim/init.lua — config managed outside Nix
    sideloadInitLua = true;
  };
}
