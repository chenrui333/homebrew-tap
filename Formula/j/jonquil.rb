class Jonquil < Formula
  desc "JSON parser on top of TOML implementation (Fortran)"
  homepage "https://github.com/toml-f/jonquil"
  url "https://github.com/toml-f/jonquil/archive/refs/tags/v0.3.2.tar.gz"
  sha256 "963f7f12128bc45dc3313df87dd4a3ba4b8ff20f38fdec2408b2a6391cf7aae2"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/toml-f/jonquil.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any, arm64_tahoe:   "1271d9d02dd8d3dfc2940e5c0655afea8fa60266dadf67d07223325399815b0a"
    sha256 cellar: :any, arm64_sequoia: "b04d185443aace7dee6f8be1793e34e7809385daaa50974a6616f750a934125d"
    sha256 cellar: :any, arm64_sonoma:  "fa49d9c2719ceaa04ea2b70780aea1037a96c1fddc948103f640556f503dae6b"
    sha256 cellar: :any, sequoia:       "6b38a1c41c157e8bfdd3c660c382ff50299c435e1fd8cc8bcff943a63a11e8d5"
    sha256 cellar: :any, arm64_linux:   "98cde101198ac5170c55c1eaebfcab958914a75a1aeaf49b44ae468545b855fc"
    sha256 cellar: :any, x86_64_linux:  "637f14b10f0e7057cc27013bfb730564bc5ec3cdf8a0ed06578326e02df6a412"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => [:build, :test]
  depends_on "chenrui333/tap/toml-f"
  depends_on "gcc" # for gfortran

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
