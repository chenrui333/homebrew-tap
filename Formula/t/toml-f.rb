class TomlF < Formula
  desc "TOML parser for data serialization/deserialization in Fortran"
  homepage "https://github.com/toml-f/toml-f"
  url "https://github.com/toml-f/toml-f/archive/refs/tags/v0.5.2.tar.gz"
  sha256 "095814952e76283a689ea957aa5bd7fc748cbe24d4ffb3a34f4f564b792dd33c"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/toml-f/toml-f.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any, arm64_tahoe:   "69abd93bd7eddb644077d2fb696a771fa192e4ec93406b058207775dc53c23e5"
    sha256 cellar: :any, arm64_sequoia: "a40f6cdaa1957bd3cfe5e52bf427963c836a8deb03862821cd030fa54fec13ba"
    sha256 cellar: :any, arm64_sonoma:  "664293e6e0586db69082e107e56939d668a56caebc7b0da745e31bcc302ebc5e"
    sha256 cellar: :any, sequoia:       "53724e11fe02106e1397667df674da15fcac6964d594e3455263713196415666"
    sha256 cellar: :any, arm64_linux:   "40dfaba7dc077fa4aeb68ed7535e60c206fccb34828dc540e70c15e9f1c42dce"
    sha256 cellar: :any, x86_64_linux:  "99bc4ec6b5674e893d0143b4586756ca9acf725144808fd752bb7cffa0e3dcdc"
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
    system formula_opt_bin("gcc")/"gfortran", "t.f90", *cflags, *libs, "-o", "test"
    assert_equal "ok", shell_output("./test").strip
  end
end
