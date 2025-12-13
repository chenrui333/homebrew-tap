class Jonquil < Formula
  desc "JSON parser on top of TOML implementation (Fortran)"
  homepage "https://github.com/toml-f/jonquil"
  url "https://github.com/toml-f/jonquil/archive/refs/tags/v0.3.0.tar.gz"
  sha256 "9742a1b15fe4e7c3332f501dcedc4f9559dfa37884ca055ff5b5508ba0901749"
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

  patch :DATA

  def install
    system "meson", "setup", "build", "-Dtests=false", *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  test do
    assert_match version.to_s, shell_output("pkg-config --modversion jonquil").strip

    (testpath/"t.f90").write <<~F90
      program t
      print *, "ok"
      end program t
    F90
    system Formula["gcc"].opt_bin/"gfortran", "t.f90", "-o", "test"
    system "./test"
  end
end

__END__
diff --git a/meson.build b/meson.build
index cbb35f0..2dd1f9c 100644
--- a/meson.build
+++ b/meson.build
@@ -77,4 +77,6 @@ if install
 endif

 # add the testsuite
-subdir('test')
+if get_option('tests')
+  subdir('test')
+endif
diff --git a/meson_options.txt b/meson_options.txt
new file mode 100644
index 0000000..93d92ff
--- /dev/null
+++ b/meson_options.txt
@@ -0,0 +1,3 @@
+# Build options for toml-f
+option('tests',
+  type: 'boolean', value: false, description: 'Build test suite')
