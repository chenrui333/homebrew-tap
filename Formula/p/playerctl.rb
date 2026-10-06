class Playerctl < Formula
  desc "Mpris media player command-line controller"
  homepage "https://github.com/altdesktop/playerctl"
  url "https://github.com/altdesktop/playerctl/archive/refs/tags/v2.4.1.tar.gz"
  sha256 "75957ad5071956f563542c7557af16a57e40b4a7f66bc9b6373d022ec5eef548"
  license "LGPL-3.0-or-later"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any, arm64_tahoe:   "94a041393e7fa04352747da1cc7ed9b0e6823956e1824fdb05588d12cd43d33f"
    sha256 cellar: :any, arm64_sequoia: "d7d1c3243d017d48ece8dfc6491009b51f0d2c174425db7728e24dab08a678f4"
    sha256 cellar: :any, arm64_linux:   "941be82aca2a84f6b15a7f70da7d8772599f3c401c47ecd5a952e185787ac3bf"
    sha256 cellar: :any, x86_64_linux:  "6c092827745c414b1d44f375dcf1f0c22c3a28b2a1227bb6cf6f1b18477640fd"
  end

  depends_on "gobject-introspection" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :build
  depends_on "glib"

  patch :DATA

  deny_network_access!

  def install
    args = %w[
      -Dgtk-doc=false
    ]
    system "meson", "setup", "build", *args, *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/playerctl --version")

    output = shell_output("#{bin}/playerctl status 2>&1", 1)
    # error as `Could not connect to players: Cannot autolaunch D-Bus without X11 $DISPLAY` on macos sequoia
    assert_match "Could not connect to players", output
  end
end

__END__
diff --git a/playerctl/meson.build b/playerctl/meson.build
index 66466fd..1d09871 100644
--- a/playerctl/meson.build
+++ b/playerctl/meson.build
@@ -48,7 +48,11 @@ deps = [
 ]

 symbols_file = join_paths(meson.project_source_root(), 'data', 'playerctl.syms')
-symbols_flag = '-Wl,--version-script,@0@'.format(symbols_file)
+if host_machine.system() == 'darwin'
+  symbols_flag = []
+else
+  symbols_flag = '-Wl,--version-script,@0@'.format(symbols_file)
+endif

 # default_library is shared by default see
 # https://mesonbuild.com/Builtin-options.html this enabled the project
