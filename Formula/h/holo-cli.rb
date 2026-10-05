class HoloCli < Formula
  desc "CLI for holo"
  homepage "https://github.com/holo-routing/holo-cli"
  url "https://github.com/holo-routing/holo-cli/archive/refs/tags/v0.5.0.tar.gz"
  sha256 "2fb4b335c4d060b431dabbe55593ddacfc8f8905b3f36d8ecbbb92d85d908f4c"
  license "MIT"
  head "https://github.com/holo-routing/holo-cli.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5a76c45649b4ba640dbd1c99d12747e820833866851ec136c7da9d304c5cc24c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b3cc23375991588c5252c04f95067a33cf9091a99245896578dc963b897c4cdb"
    sha256 cellar: :any,                 arm64_linux:   "ecc0f033718bb9ed2fd859e0b3a66f4634a8d30594dd3a18f3e939cc4432bd92"
    sha256 cellar: :any,                 x86_64_linux:  "7e21690a0619d42e473e08d9e85538f3129df860be46b7e4ea0457d1d2281542"
  end

  depends_on "cmake" => :build
  depends_on "protobuf" => :build
  depends_on "rust" => :build
  depends_on "pcre2"

  patch :DATA

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/holo-cli --version")
  end
end

__END__
diff --git a/Cargo.lock b/Cargo.lock
--- a/Cargo.lock
+++ b/Cargo.lock
@@ -537,7 +537,7 @@ checksum = "fbd780fe5cc30f81464441920d82ac8740e2e46b29a6fad543ddd075229ce37e"
 
 [[package]]
 name = "holo-cli"
-version = "0.4.0"
+version = "0.5.0"
 dependencies = [
  "clap",
  "derive-new",
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
