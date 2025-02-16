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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "11f9a9d25e3f4d516db8dec3bf4b8d8453991f78b67a2dd4d6752d5320e8d3c7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b76651f29117b591a2c463ba680eb5db13c9d1321207eba7f86fc981ff3b3f6f"
    sha256 cellar: :any_skip_relocation, ventura:       "b6a8cfd7c439ea95952b33b351c2c64643f6503b8b0435418f9df40d93d7ec0f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ba6e9319564ede81fe0f189a1e63b1f352dcf68fa2657125cc49a18e58567d24"
  end

  depends_on "rust" => :build

  patch :DATA

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
