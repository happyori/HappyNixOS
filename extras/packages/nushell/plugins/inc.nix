{
  rustPlatform,
  nushell,
  nix-update-script,
}: let
  pname = "nu_plugin_inc";
in
  rustPlatform.buildRustPackage {
    inherit pname;
    inherit (nushell) version src;
    cargoHash = "sha256-quY9WX9AnObh2qM52ggYba7G4Kon3J4QCBVySZBWTkE=";
    cargoBuildFlags = ["--package ${pname}"];

    checkPhase = ''
      cargo test --manifest-path crates/${pname}/Cargo.toml
    '';

    passthru.updateScript = nix-update-script {
      extraArgs = ["--version=skip"];
    };
  }
