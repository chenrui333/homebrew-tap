class Superclaude < Formula
  desc "AI-powered development toolkit"
  homepage "https://www.superclaude.sh/"
  url "https://registry.npmjs.org/superclaude/-/superclaude-1.3.0.tgz"
  sha256 "9ab3f890f36a6f6895516c7c2eb9cd645a012c7bf8e6f3fb0fb7ba3bd18cc75b"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "461ae6a3bbeb20525f06f546496dcfc7d0e4c5737b001d9d1c268aec4baabc1e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "86758bac262253e192c5843716bf79e29f83fd97fb7fab3906d7aedeef483246"
    sha256 cellar: :any_skip_relocation, ventura:       "89901ed6161658d27f069a316a6e75262462888bb319663cb69093e8fcd40d08"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "42a5f2935764e1cad2774308673288e4888bf513391dbfdae1f46e981a466120"
  end

  depends_on "node"

  patch :DATA

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
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
