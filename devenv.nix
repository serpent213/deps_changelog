{
  pkgs,
  lib,
  config,
  inputs,
  ...
}: {
  # https://devenv.sh/packages/
  packages = with pkgs;
      [
        git
        # Nix code formatter
        alejandra
      ];

  # https://devenv.sh/languages/
  languages.elixir.enable = true;

  # See full reference at https://devenv.sh/reference/options/
}
