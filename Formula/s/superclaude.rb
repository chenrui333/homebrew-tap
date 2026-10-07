class Superclaude < Formula
  desc "AI-powered development toolkit"
  homepage "https://www.superclaude.sh/"
  url "https://registry.npmjs.org/superclaude/-/superclaude-1.3.0.tgz"
  sha256 "9ab3f890f36a6f6895516c7c2eb9cd645a012c7bf8e6f3fb0fb7ba3bd18cc75b"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c59f563a078981432e9fc369508429f7996d7a9fc1851635240d7c8266c3bfc6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c59f563a078981432e9fc369508429f7996d7a9fc1851635240d7c8266c3bfc6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "260ee15e82ebad1604de89e7fa89a81a770e0cd6f030a84d25e1d14d39e9878c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "260ee15e82ebad1604de89e7fa89a81a770e0cd6f030a84d25e1d14d39e9878c"
  end

  depends_on "node"

  patch :DATA

  deny_network_access!

  def fetch
    system "npm", "install", *std_npm_args(prefix: buildpath/"npm-fetch")
  end

  def install
    rm_r buildpath/"npm-fetch"
    system "npm", "install", "--offline", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/superclaude --version")

    assert_match "commit", shell_output("#{bin}/superclaude help")

    output = shell_output("#{bin}/superclaude --not-a-real-flag 2>&1", 1)
    assert_match "Unknown flag: --not-a-real-flag", output
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
