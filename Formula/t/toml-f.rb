class TomlF < Formula
  desc "TOML parser for data serialization/deserialization in Fortran"
  homepage "https://github.com/toml-f/toml-f"
  url "https://github.com/toml-f/toml-f/archive/refs/tags/v0.4.3.tar.gz"
  sha256 "d7fdd12a68c2e433785f453b20c1984bed037d213a35d8f0946da7e7f6b89c45"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/toml-f/toml-f.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any,                 arm64_sequoia: "77a1ee63bb0dda4d4bc5e1be2c4f2d28671ad221ad49713ab09655c4e531a9fd"
    sha256 cellar: :any,                 arm64_sonoma:  "b2fd6d8fec542cc3055120f0bc172887646557c1cff7003c2b9194d86c60d98c"
    sha256 cellar: :any,                 ventura:       "e4cbd1f69deae36ca71ce351da9a1e1c8eeb81e62b9d8f8a500e87651e8e79bc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2adb1692cb1d4428a661a1622c7cf03016cfca54d47af5b4895635ae2e01390f"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => [:build, :test]
  depends_on "gcc" # provides gfortran

  def install
    system "meson", "setup", "build", "-Dtests=false", *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  test do
    assert_match version.to_s, shell_output("pkgconf --modversion toml-f")

    (testpath/"t.f90").write <<~F90
      program t
        print *, "ok"
      end program t
    F90
    cflags = shell_output("pkgconf --cflags toml-f").chomp.split
    libs   = shell_output("pkgconf --libs toml-f").chomp.split
    system Formula["gcc"].opt_bin/"gfortran", "t.f90", *cflags, *libs, "-o", "test"
    assert_equal "ok", shell_output("./test").strip
  end
end
