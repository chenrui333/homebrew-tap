class Jonquil < Formula
  desc "JSON parser on top of TOML implementation (Fortran)"
  homepage "https://github.com/toml-f/jonquil"
  url "https://github.com/toml-f/jonquil/archive/refs/tags/v0.3.0.tar.gz"
  sha256 "9742a1b15fe4e7c3332f501dcedc4f9559dfa37884ca055ff5b5508ba0901749"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/toml-f/jonquil.git", branch: "main"

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
