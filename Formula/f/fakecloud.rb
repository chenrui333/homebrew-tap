# frozen_string_literal: true

class Fakecloud < Formula
  desc "Free, open-source local AWS cloud emulator for integration testing"
  homepage "https://github.com/faiscadev/fakecloud"
  url "https://github.com/faiscadev/fakecloud/archive/refs/tags/v0.13.1.tar.gz"
  sha256 "7602c207671296afb522a59eb1a9947e061f0c5a9cf1df6babef77a02b02f8cd"
  license "AGPL-3.0-or-later"
  head "https://github.com/faiscadev/fakecloud.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "116c825d6e9a0e82c346425bf715532d758b51aa2ad74fd764f3c27b68fee484"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "afad3d74161f1d2e8459572ca15be23e13ce7fd180b397e396492550820a2205"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ae7d8bf40c644d14a341fb21dfe4fe4dc697ffd5465c48e1390016b57c4de359"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "34266b45017866b783577111e3d22caf8111e4b080584a8be0461cc79e9e58ff"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e4e424ff19c70830650df2fde2aa91a2f6ae9e56a72d552b4e28c4b6632a9328"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "openssl@3"
    depends_on "zlib-ng-compat"
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/fakecloud-server")
  end

  service do
    run [opt_bin/"fakecloud"]
    keep_alive true
  end

  test do
    port = free_port
    fork do
      exec bin/"fakecloud", "--addr", "127.0.0.1:#{port}"
    end
    sleep 3

    output = shell_output("curl -s http://127.0.0.1:#{port}/_fakecloud/health 2>&1")
    assert_match "ok", output.downcase

    assert_match version.to_s, shell_output("#{bin}/fakecloud --version")
  end
end
