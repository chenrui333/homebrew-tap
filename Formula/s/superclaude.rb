class Superclaude < Formula
  desc "AI-powered development toolkit"
  homepage "https://www.superclaude.sh/"
  url "https://registry.npmjs.org/superclaude/-/superclaude-1.0.3.tgz"
  sha256 "f292b6c18f01985382f51f40ad5c2fe0e91cf2f3121a7295b8f2294610b02312"
  license "MIT"

  depends_on "node"

  patch :DATA

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/superclaude --version")

    output = shell_output("#{bin}/superclaude readme 2>&1", 1)
    assert_match "System dependencies check...", output
    assert_match "Claude Code not found", output
  end
end

__END__
diff --git a/bin/superclaude b/bin/superclaude
index 408bc00..8ae9d52 100755
--- a/bin/superclaude
+++ b/bin/superclaude
@@ -1,4 +1,4 @@
-#!/bin/sh
+#!/usr/bin/env bash
 
 # SuperClaude - AI-powered development toolkit
 # Usage: ./scripts/superclaude.sh <command> [flags]
