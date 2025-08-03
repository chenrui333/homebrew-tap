class Superclaude < Formula
  desc "AI-powered development toolkit"
  homepage "https://www.superclaude.sh/"
  url "https://registry.npmjs.org/superclaude/-/superclaude-1.3.0.tgz"
  sha256 "9ab3f890f36a6f6895516c7c2eb9cd645a012c7bf8e6f3fb0fb7ba3bd18cc75b"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "58d03c6878c6b55e7495b080acb9aba14cb76e4185327c84a0396b2326230261"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d6e07aa5c252582109fd14ababf1333f1131706dae3e767f5fe1745eb7bb3ce0"
    sha256 cellar: :any_skip_relocation, ventura:       "2e89444577d93c0b0cfa00608711b00fd05e91ba66bff360519382fcce06de9c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a705bed6cbb6a20f0bcf4ed7083d959bee0b5da154254e8352a383ff160b0bea"
  end

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
