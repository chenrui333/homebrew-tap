class Blindfold < Formula
  desc "Generator of .gitignore files using gitignore.io"
  homepage "https://github.com/Eoin-McMahon/Blindfold"
  url "https://github.com/Eoin-McMahon/blindfold/archive/refs/tags/v1.2.0.tar.gz"
  sha256 "526ca5d4361a24ea6cb3422515c04519d2b738bab86de52358099ec37a61d59d"
  license "MIT"
  head "https://github.com/Eoin-McMahon/Blindfold.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ebef06ba6e4c47b49ba089f2faa3f90bb56c5ca7a7abc12b6aaec5fd3309b72a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "78d3314f7543b97a893c34b1487f354eaa07b9d96e1fc7c8ec10a38630354643"
    sha256 cellar: :any_skip_relocation, ventura:       "1ee56105052adcf92bf62f042c1f05743add140faaf53a9fc85f382b2ad2a0ac"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5b0c68e137a5011b79ac725055b42676b8acaa9547b6fc38df08e96f4939fcc2"
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
