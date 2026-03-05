class TomlF < Formula
  desc "TOML parser for data serialization/deserialization in Fortran"
  homepage "https://github.com/toml-f/toml-f"
  url "https://github.com/toml-f/toml-f/archive/refs/tags/v0.5.0.tar.gz"
  sha256 "a9e546221d788416fa6ca8d8550a79d1adf983a2a67b5c9ef57ae79fb02c9df0"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/toml-f/toml-f.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any,                 arm64_tahoe:   "41683d4feb98a35ee34f6916b1188ec11ca7c98512d855ac8622a2614b1a0d6d"
    sha256 cellar: :any,                 arm64_sequoia: "137a3501aaf9d2245877320a4c9d0ed783dadf396e0eae2e3b225fcc793eb2be"
    sha256 cellar: :any,                 arm64_sonoma:  "55ba3925152c22a348935710493905dd45e7b51d34c994aa230f489a13e4380f"
    sha256 cellar: :any,                 sequoia:       "df8bf324cda197c2a4a72ae64f9f4517da5025ee62f1318e309ffe3618f7e414"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "692ac4401a6bb475ce74d6ea457eb95d4befabdb4e8ed704dbc4a0f4073a3fc9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7b9e8b620da21e066ac4931db753fa5706b27f725293cc352c3ce27e3cf7cfa3"
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
