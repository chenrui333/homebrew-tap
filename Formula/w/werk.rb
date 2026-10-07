class Werk < Formula
  desc "Simplistic command runner and build system"
  homepage "https://github.com/simonask/werk"
  url "https://github.com/simonask/werk/archive/0e713512b1a45d94439a4de5064579af8a53607e.tar.gz"
  version "0.1.0"
  sha256 "a592ba4abf6bc64dbe801d96061cf28612358ced8b6db8a2c08d3b54ecb13583"
  license any_of: ["Apache-2.0", "MIT"]
  revision 1

  livecheck do
    skip "no tagged releases"
  end

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "95cd5f5092ade035f824ab29e2200d9809a75a0fed676be07cbf1e658bda8f0c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "92ad42c8b2256d031f58747169fef682ee96b035a586778b1b8be089f9a325d0"
    sha256 cellar: :any,                 arm64_linux:   "ed9da3d86ee2c14fb3ae32f8f2ade43c1f68d94717bd5b04f7531c9dfcad4a1b"
    sha256 cellar: :any,                 x86_64_linux:  "cc7e8b7613a21809327a370b47a7a961aeb64b47bde7906aacff5af43da9d56c"
  end

  depends_on "rust" => :build

  patch :DATA

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "werk-cli")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/werk --version")

    (testpath/"Werkfile").write <<~EOS
      default target = "hello"

      task hello {
          info "Hello, World!"
      }
    EOS

    output = shell_output("#{bin}/werk 2>&1")
    assert_match <<~EOS, output
      [info] Hello, World!
      [ ok ] hello
    EOS
  end
end

__END__
diff --git a/werk-cli/main.rs b/werk-cli/main.rs
index 6f87d0e..1950290 100644
--- a/werk-cli/main.rs
+++ b/werk-cli/main.rs
@@ -18,12 +18,24 @@ use werk_util::{Diagnostic, DiagnosticError, DiagnosticFileRepository, Diagnosti
 shadow_rs::shadow!(build);

 fn version_string() -> String {
-    format!(
-        "{} ({} {})",
-        build::PKG_VERSION,
-        &build::COMMIT_HASH[0..8],
+    // Use a default value if commit hash or build time is empty.
+    let commit = if build::COMMIT_HASH.len() >= 8 {
+        &build::COMMIT_HASH[0..8]
+    } else if build::COMMIT_HASH.is_empty() {
+        "dev"
+    } else {
+        &build::COMMIT_HASH
+    };
+
+    let build_time = if build::BUILD_TIME.len() >= 10 {
         &build::BUILD_TIME[0..10]
-    )
+    } else if build::BUILD_TIME.is_empty() {
+        "unknown"
+    } else {
+        &build::BUILD_TIME
+    };
+
+    format!("{} ({} {})", build::PKG_VERSION, commit, build_time)
 }

 #[derive(clap::Args, Debug)]
