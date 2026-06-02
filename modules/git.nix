_:

{
  programs.git = {
    enable = true;

    settings = {
      user = {
        name = "Yong, Samuel Wai Weng";
        email = "samuelwaiweng.yong@accenture.com";
      };
      init.defaultBranch = "main";
      push.autoSetupRemote = true;
      pull.rebase = true;
      rebase.autoStash = true;

      core = {
        autocrlf = "input"; # LF on checkout — critical for WSL/Windows cross-dev
        editor = "nvim";
      };
    };
  };
}
