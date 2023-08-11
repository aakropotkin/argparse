{ lib, stdenv, cmake }: stdenv.mkDerivation {
  pname     = "argparse";
  version   = "2.10-pre";
  src       = builtins.path { path = ./.; };
  postPatch = ''
    substituteInPlace CMakeLists.txt                                         \
      --replace '$'{CMAKE_INSTALL_LIBDIR_ARCHIND} '$'{CMAKE_INSTALL_LIBDIR};
    substituteInPlace packaging/pkgconfig.pc.in         \
      --replace '$'{prefix}/@CMAKE_INSTALL_INCLUDEDIR@  \
                @CMAKE_INSTALL_FULL_INCLUDEDIR@;
  '';
  nativeBuildInputs = [cmake];
  meta              = {
    description = "Argument Parser for Modern C++";
    homepage    = "https://github.com/aakropotkin/argparse";
    platforms   = lib.platforms.unix;
    license     = lib.licenses.mit;
  };
}
