class Jonquil < Formula
  desc "JSON parser on top of TOML implementation (Fortran)"
  homepage "https://github.com/toml-f/jonquil"
  url "https://github.com/toml-f/jonquil/archive/refs/tags/v0.3.2.tar.gz"
  sha256 "963f7f12128bc45dc3313df87dd4a3ba4b8ff20f38fdec2408b2a6391cf7aae2"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/toml-f/jonquil.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any,                 arm64_tahoe:   "377d5d5d1309e545d18951f66b51dba871200a6d6ee58aca35c560d2e3691fcb"
    sha256 cellar: :any,                 arm64_sequoia: "e6c03f53f4f5a8829215f0a5887f109b2a147a789b24b5863da7e71340c28fb0"
    sha256 cellar: :any,                 arm64_sonoma:  "7c76070aa34a47b240403855542bf56b3a2195c481d80062af3c350a270c7990"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "84f50b1ee056ad2d93e5541eb7cd74534c3a447c661fcc07ae7198bc060c43d8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fe3fced4178b3e8e4707d1173ea0bb12807756668553d074a3812bae34744014"
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
