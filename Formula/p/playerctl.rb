class Playerctl < Formula
  desc "Mpris media player command-line controller"
  homepage "https://github.com/altdesktop/playerctl"
  url "https://github.com/altdesktop/playerctl/archive/refs/tags/v2.4.1.tar.gz"
  sha256 "75957ad5071956f563542c7557af16a57e40b4a7f66bc9b6373d022ec5eef548"
  license "LGPL-3.0-or-later"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any, arm64_sequoia: "3bc5b8843f47a4b9517736dc6afad3c2ed725f504ed37a9802f1a75504eeb6c1"
    sha256 cellar: :any, arm64_sonoma:  "705566ce3324ebbb5d6e222870aa7b1ab6c89791aaebd1539c4841ba964a5344"
    sha256 cellar: :any, ventura:       "c164e90f1fa996873ec930b036f7ba7ec60da88faf6df286b38c524765e873d6"
    sha256               x86_64_linux:  "8a4452fde91c17b09038390f3c96d41871b9d5e27552ec27997942a49ced81a3"
  end

  depends_on "gobject-introspection" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :build
  depends_on "glib"

  patch :DATA

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
