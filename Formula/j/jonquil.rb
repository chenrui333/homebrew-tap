class Jonquil < Formula
  desc "JSON parser on top of TOML implementation (Fortran)"
  homepage "https://github.com/toml-f/jonquil"
  url "https://github.com/toml-f/jonquil/archive/refs/tags/v0.3.2.tar.gz"
  sha256 "963f7f12128bc45dc3313df87dd4a3ba4b8ff20f38fdec2408b2a6391cf7aae2"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/toml-f/jonquil.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 2
    sha256 cellar: :any, arm64_tahoe:   "6865cc6c28278b8750e2f7f7fa47e4974ef0a0aa17c7f8e428777021493fc1a8"
    sha256 cellar: :any, arm64_sequoia: "59aa512031d681e39e1393a9398470c253c4533f9c119d953a74df626755fcdf"
    sha256 cellar: :any, arm64_linux:   "0f6156d81e2f0b3619036b4a33d4643ce440d6b235ccef99cfd746797555519d"
    sha256 cellar: :any, x86_64_linux:  "79751b6591e63998059b30a76f970b3aae342ed2fb549abb42f7ecbe77b53bf6"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => [:build, :test]
  depends_on "chenrui333/tap/toml-f"
  depends_on "gcc" # for gfortran

  deny_network_access!

  def install
    inreplace "meson.build", "description: 'Bringing TOML blooms to JSON land',", <<~MESON.chomp
      description: 'Bringing TOML blooms to JSON land',
          requires: 'toml-f',
    MESON

    system "meson", "setup", "build", "-Dtests=false", *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  test do
    assert_match version.to_s, shell_output("pkg-config --modversion jonquil").strip

    (testpath/"t.f90").write <<~F90
      program t
        use jonquil_version, only : get_jonquil_version
        implicit none

        character(len=:), allocatable :: lib_version
        call get_jonquil_version(string=lib_version)
        print '(a)', lib_version
      end program t
    F90
    cflags = shell_output("pkgconf --cflags jonquil").chomp.split
    libs = shell_output("pkgconf --libs jonquil").chomp.split
    system formula_opt_bin("gcc")/"gfortran", "t.f90", *cflags, *libs, "-o", "test"
    assert_match version.to_s, shell_output("./test").strip
  end
end
