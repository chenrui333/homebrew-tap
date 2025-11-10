class TomlF < Formula
  desc "TOML parser for data serialization/deserialization in Fortran"
  homepage "https://github.com/toml-f/toml-f"
  url "https://github.com/toml-f/toml-f/archive/refs/tags/v0.4.3.tar.gz"
  sha256 "d7fdd12a68c2e433785f453b20c1984bed037d213a35d8f0946da7e7f6b89c45"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/toml-f/toml-f.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any,                 arm64_tahoe:   "211515a9dded53203675fe561e1fd209d7cd7236168176ece9ca916c747cc7fd"
    sha256 cellar: :any,                 arm64_sequoia: "13167789866354dfc657d6509e8f68d9922ad0f17229eab74d91f2cb4e7a4888"
    sha256 cellar: :any,                 arm64_sonoma:  "ab647d60e8a8f3f51bb3e106651178422ac586a00b86089d12bd29d93b9b5d3f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9eb7c99f1c41945af0f5684b968e386d5226ab89120bda58fb57397f897b4f67"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "717a3eeb6b6c990c6362f7051c78749a847fde84d34953484d76dfd4e3021734"
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
