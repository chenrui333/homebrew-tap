class Blindfold < Formula
  desc "Generator of .gitignore files using gitignore.io"
  homepage "https://github.com/Eoin-McMahon/Blindfold"
  url "https://github.com/Eoin-McMahon/blindfold/archive/refs/tags/v1.2.0.tar.gz"
  sha256 "526ca5d4361a24ea6cb3422515c04519d2b738bab86de52358099ec37a61d59d"
  license "MIT"
  head "https://github.com/Eoin-McMahon/Blindfold.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "877eca16cbd5d3f6e73e6bca90e6d4d9e6d03f1fb8448d6e8353eb1e2b38aa04"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1d764a7d46151e5059571c9a7d85388d16605e16a3a74d72391e793922cc0e7d"
    sha256 cellar: :any_skip_relocation, ventura:       "227f7227b14333a8bf12279df1f9fef9d3f3c3b282770c0a992e36a47e9e344e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4cafd2904cccfb3d60ca0def9e7687375f19aefc62b888607a2af866fba93e3e"
  end

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
diff --git a/Cargo.toml b/Cargo.toml
index 5d0c964..32b693e 100644
--- a/Cargo.toml
+++ b/Cargo.toml
@@ -1,6 +1,6 @@
 [package]
 name = "blindfold"
-version = "1.1.0"
+version = "1.2.0"
 authors = ["Eóin McMahon <eoin.mcmahon.dev@gmail.com>"]
 edition = "2018"
 description ="gitignore file generator written in rust"
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
