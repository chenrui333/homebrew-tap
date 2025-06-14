class HoloCli < Formula
  desc "CLI for holo"
  homepage "https://github.com/holo-routing/holo-cli"
  url "https://github.com/holo-routing/holo-cli/archive/refs/tags/v0.5.0.tar.gz"
  sha256 "2fb4b335c4d060b431dabbe55593ddacfc8f8905b3f36d8ecbbb92d85d908f4c"
  license "MIT"
  head "https://github.com/holo-routing/holo-cli.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any,                 arm64_sequoia: "fdb665f3e9dad32608016a112491a3381e0364928e8a47a94e35c47ee0bb88a4"
    sha256 cellar: :any,                 arm64_sonoma:  "34938c420e237b0325c20294a54311fcbbcb456dfaef13f487040caab772676c"
    sha256 cellar: :any,                 ventura:       "942e50ed4f3ad94b0d1902bb9b2c42d4b5969f01006a6037c18c45b992434ad9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a0e939365c9e7dba2df7b15b0da9b2d2c74889db0090da1e4f955a4e455a6a9f"
  end

  depends_on "cmake" => :build
  depends_on "protobuf" => :build
  depends_on "rust" => :build
  depends_on "pcre2"

  patch :DATA

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/holo-cli --version")
  end
end

__END__
diff --git a/src/internal_commands.rs b/src/internal_commands.rs
index 4ba84b7..9d404c0 100644
--- a/src/internal_commands.rs
+++ b/src/internal_commands.rs
@@ -71,10 +71,10 @@ impl<'a> YangTableBuilder<'a> {
     where
         S: AsRef<str>,
     {
-        if let Some(value) = value
-            && let Some((xpath, _)) = self.paths.last_mut()
-        {
-            *xpath = format!("{}[{}='{}']", xpath, key, value.as_ref());
+        if let Some(value) = value {
+            if let Some((xpath, _)) = self.paths.last_mut() {
+                *xpath = format!("{}[{}='{}']", xpath, key, value.as_ref());
+            }
         }
         self
     }
diff --git a/src/main.rs b/src/main.rs
index 71ecb48..00dc9c7 100644
--- a/src/main.rs
+++ b/src/main.rs
@@ -4,8 +4,6 @@
 // SPDX-License-Identifier: MIT
 //

-#![feature(let_chains)]
-
 mod client;
 mod error;
 mod internal_commands;
diff --git a/src/parser.rs b/src/parser.rs
index 7bfe1cd..94f5839 100644
--- a/src/parser.rs
+++ b/src/parser.rs
@@ -180,10 +180,10 @@ pub(crate) fn parse_command(
     let mut token_id_child = wd_token_id;
     for token_id in wd_token_id.ancestors(&commands.arena) {
         // Update CLI node when traversing a YANG list.
-        if let Some(token) = commands.get_opt_token(token_id)
-            && token.node_update
-        {
-            session.mode_config_exit();
+        if let Some(token) = commands.get_opt_token(token_id) {
+            if token.node_update {
+                session.mode_config_exit();
+            }
         }
         // Ignore list keys that can match on everything.
         match commands.get_opt_token(token_id_child) {
