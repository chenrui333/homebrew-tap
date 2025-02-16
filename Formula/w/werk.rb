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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9a8cead57b43778fd064e5a1d60a3155451119d321a9e286252522429d78f33e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2354f37a29a0bf26659a19c2336a29150faf44539156b977ca3d44a1e0dd4021"
    sha256 cellar: :any_skip_relocation, ventura:       "c68257ade093796112508384e08f59902189b715a91968227ec2df34ef33130c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6cb96a3c380ccb88c17b789b343f57f3e5331db01fe6a03b6a24d0c52bf9b652"
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
