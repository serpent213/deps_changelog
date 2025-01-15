{
  pkgs,
  lib,
  config,
  inputs,
  ...
}: let
  pkgs-stable = import inputs.nixpkgs-stable {system = pkgs.stdenv.system;};
in {
  # https://devenv.sh/packages/
  packages = with pkgs; [
    git
    # Nix code formatter
    alejandra
  ];

  # https://devenv.sh/languages/
  languages.elixir.enable = true;
  # languages.elixir.package = pkgs-stable.elixir_1_18;

  # See full reference at https://devenv.sh/reference/options/
}
