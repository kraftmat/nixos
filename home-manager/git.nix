{ ... }:

{
  programs.git = {
    enable = true;
    settings = {
      user = {
        name = "kraftmat";
        email = "kraftmat@cerf.ygg";
      };
      credential."https://github.com".helper = "!gh auth git-credential";
      credential."https://gist.github.com".helper = "!gh auth git-credential";
    };
  };
}
