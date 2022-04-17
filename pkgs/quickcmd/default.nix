{ stdenv, wofi }:

stdenv.mkDerivation {
  pname = "quickcmd";
  version = "0.0.1";
  src = builtins.path {
    name = "quickcmd";
    path = ./.;
  };

  buildInputs = [
    wofi
  ];

  installPhase = ''
    mkdir -p $out/bin/
    cp -R $src/cmds $out/cmds
    cp $src/quickcmd.sh $out/bin/quickcmd
    chmod -R +x $out
  '';
}
