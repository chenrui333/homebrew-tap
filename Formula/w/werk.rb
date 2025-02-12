class Werk < Formula
  desc "Simplistic command runner and build system"
  homepage "https://github.com/simonask/werk"
  url "https://github.com/simonask/werk/archive/7e565556b33b8b9eb4bfbb62495bfb97263e1480.tar.gz"
  version "0.1.0"
  sha256 "812a417b2f86fc9d09ece394eb400fab53b5a1431f5613a8f9693d20a39cf449"
  license any_of: ["Apache-2.0", "MIT"]

  livecheck do
    skip "no tagged releases"
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
