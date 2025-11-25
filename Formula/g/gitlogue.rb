class Gitlogue < Formula
  desc "Git commit history replay"
  homepage "https://github.com/unhappychoice/gitlogue"
  url "https://github.com/unhappychoice/gitlogue/archive/refs/tags/v0.4.1.tar.gz"
  sha256 "0e1733b19f8e7c43ef7051a92a3c6518bbb56ab6b42ed30a82b7c068e469d02f"
  license "ISC"
  head "https://github.com/unhappychoice/gitlogue.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a9c63adbfe91cd354e4e131560be695697db366c336d921b2d1c6224f5e3d377"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9d9dd021622b526b7589a2ec34acb40e9bfa69c74ec96a736c446455e128981d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "00f4d253e73eaa2a7beac1ffe07c1f7cc0a4d11f2605d8b6a1dc165c782ccb88"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4d9472ca097e4753d6e6e2e664bd3dc87a9008448deec30d17ed8003bbb7fc15"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "080a63fb78597db98ffeddf8628770b13672af1d74677703451f176445b93b01"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "openssl@3"

  uses_from_macos "zlib"

  # upstream pr ref, https://github.com/unhappychoice/gitlogue/pull/95
  patch :DATA

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gitlogue --version")
    assert_match "ayu-dark", shell_output("#{bin}/gitlogue theme list")
  end
end

__END__
diff --git a/src/main.rs b/src/main.rs
index ea2281a..b996926 100644
--- a/src/main.rs
+++ b/src/main.rs
@@ -25,8 +25,8 @@ pub enum PlaybackOrder {

 #[derive(Parser, Debug)]
 #[command(
-    name = "git-logue",
-    version = "0.0.1",
+    name = "gitlogue",
+    version = "0.3.0",
     about = "A Git history screensaver - watch your code rewrite itself",
     long_about = "git-logue is a terminal-based screensaver that replays Git commits as if a ghost developer were typing each change by hand. Characters appear, vanish, and transform with natural pacing and syntax highlighting."
 )]
