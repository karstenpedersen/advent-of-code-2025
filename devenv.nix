{ pkgs, ... }:

{
  # https://devenv.sh/packages/
  packages = with pkgs; [
    inotify-tools
  ];

  # https://devenv.sh/languages/
  languages.gleam.enable = true;
}
