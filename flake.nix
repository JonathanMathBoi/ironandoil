{
  description = "Website for Iron and Oil Christian Fellowship";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    rust-overlay = {
      url = "github:oxalica/rust-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      flake-utils,
      rust-overlay,
      ...
    }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        overlays = [ (import rust-overlay) ];
        pkgs = import nixpkgs {
          inherit system overlays;
        };
        rustToolchain = pkgs.rust-bin.fromRustupToolchainFile ./rust-toolchain.toml;
      in
      {
        devShells.default = pkgs.mkShell {
          packages = with pkgs; [
            # Rustup containing Rust tools
            rustToolchain

            pkg-config
            openssl
            sqlite

            sqlx-cli
            bacon

            tailwindcss
          ];

          shellHook = ''
            echo "Iron and Oil Web Dev Environment Loaded"
            echo "Rust: $(rustc --version)"
            echo "Sqlite: $(sqlite3 --version | cut -d' ' -f1)"
          '';
        };
      }
    );
}
