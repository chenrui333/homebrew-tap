class Blindfold < Formula
  desc "Generator of .gitignore files using gitignore.io"
  homepage "https://github.com/Eoin-McMahon/Blindfold"
  url "https://github.com/Eoin-McMahon/blindfold/archive/refs/tags/v1.1.0.tar.gz"
  sha256 "b3d515cf57e1925bd027be4431d856708c808a2288023b9019008b1afb0d8730"
  license "MIT"
  head "https://github.com/Eoin-McMahon/Blindfold.git", branch: "master"

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "openssl@3"
  end

  patch :DATA

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/blindfold --version")

    assert_match "homebrew", shell_output("#{bin}/blindfold list")
  end
end

__END__
diff --git a/src/cli.rs b/src/cli.rs
index 8205fb4..fd54e5f 100644
--- a/src/cli.rs
+++ b/src/cli.rs
@@ -4,7 +4,7 @@ use clap::{Parser, Subcommand, ValueEnum};
 #[derive(Parser)]
 #[command(
     name = "Blindfold",
-    version = "1.0",
+    version = env!("CARGO_PKG_VERSION"),
     author = "Eoin McMahon",
     about = "Generator of .gitignore files using gitignore.io"
 )]
