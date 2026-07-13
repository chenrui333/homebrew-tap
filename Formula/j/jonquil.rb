class Jonquil < Formula
  desc "JSON parser on top of TOML implementation (Fortran)"
  homepage "https://github.com/toml-f/jonquil"
  url "https://github.com/toml-f/jonquil/archive/refs/tags/v0.3.2.tar.gz"
  sha256 "963f7f12128bc45dc3313df87dd4a3ba4b8ff20f38fdec2408b2a6391cf7aae2"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/toml-f/jonquil.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any, arm64_tahoe:   "f15f5d2f9389f9865ebdeac293ce6c49fb25414b42f6c9577c2603fa607be58d"
    sha256 cellar: :any, arm64_sequoia: "0920cec77ef3fb8620b77cf16ee06d56501d9534f35e37a0e94464868783fbd3"
    sha256 cellar: :any, arm64_sonoma:  "894e732bb0006f9a8168bf05da79a2995e1b3d9a2a7692f5e01dfada5fa6f599"
    sha256 cellar: :any, sequoia:       "29520bd1476224ebe60a84b7dbda9d22bacbfd654186ff05eabdaeaad4b9acb9"
    sha256 cellar: :any, arm64_linux:   "7c4129d0e32db1561cf0376c82bee19275fe4410fcf421aafdcd4fc92909e84e"
    sha256 cellar: :any, x86_64_linux:  "2ad8fe42b63d4afdcb811260d86aad6d551c20d4d94bef0bd4ae5e2ea2c08314"
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
        use jonquil
        implicit none

        class(json_value), allocatable :: data
        type(json_object), pointer :: object
        character(:), allocatable :: name
        integer :: count

        call json_loads(data, '{"name": "Fortran", "count": 42}')
        object => cast_to_object(data)
        call get_value(object, "name", name)
        call get_value(object, "count", count)

        print '(a,a)', "Name: ", name
        print '(a,i0)', "Count: ", count
      end program t
    F90
    cflags = shell_output("pkgconf --cflags jonquil").chomp.split
    libs = shell_output("pkgconf --libs jonquil").chomp.split
    system formula_opt_bin("gcc")/"gfortran", "t.f90", *cflags, *libs, "-o", "test"
    output = shell_output("./test")
    assert_match "Name: Fortran", output
    assert_match "Count: 42", output
  end
end
