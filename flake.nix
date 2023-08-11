# ============================================================================ #
#
#
#
# ---------------------------------------------------------------------------- #

{

# ---------------------------------------------------------------------------- #

  inputs.nixpkgs.url = "github:NixOS/nixpkgs";


# ---------------------------------------------------------------------------- #

  outputs = { nixpkgs, ... }: let

# ---------------------------------------------------------------------------- #

    eachDefaultSystemMap = let
      defaultSystems = [
        "x86_64-linux" "aarch64-linux" "x86_64-darwin" "aarch64-darwin"
      ];
    in fn: let
      proc = system: { name = system; value = fn system; };
    in builtins.listToAttrs ( map proc defaultSystems );


# ---------------------------------------------------------------------------- #

    overlays.deps      = final: prev: {};
    overlays.argparse = final: prev: {
      argparse = final.callPackage ./pkg-fun.nix {};
    };
    overlays.default = nixpkgs.lib.composeExtensions overlays.deps
                                                     overlays.argparse;


# ---------------------------------------------------------------------------- #

  in {

    inherit overlays;

    packages = eachDefaultSystemMap ( system: let
      pkgsFor = ( builtins.getAttr system nixpkgs.legacyPackages ).extend
                  overlays.default;
    in {
      inherit (pkgsFor) argparse;
      default = pkgsFor.argparse;
    } );


  };


# ---------------------------------------------------------------------------- #


}


# ---------------------------------------------------------------------------- #
#
#
#
# ============================================================================ #
