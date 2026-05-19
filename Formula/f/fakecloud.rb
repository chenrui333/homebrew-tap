# frozen_string_literal: true

class Fakecloud < Formula
  desc "Free, open-source local AWS cloud emulator for integration testing"
  homepage "https://github.com/faiscadev/fakecloud"
  url "https://github.com/faiscadev/fakecloud/archive/refs/tags/v0.15.0.tar.gz"
  sha256 "9e09490058b64617c98410762a1d291986e58a61a8a27f3a59c23f5590ed0444"
  license "AGPL-3.0-or-later"
  head "https://github.com/faiscadev/fakecloud.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a65e9132cf1c3f7a0428186a7d57758502f35f97f1447075b3b684730aa5e2e6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d050aa7fa008d9ee53868855578f5016a547a13685deb2e6bb5aa13c33009445"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2ea4e159f9c325b9769e7dfd6d1b556c22857eb9a7fd29502ab23063060d486b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c499edd1e855f23519ba2901c0f708a015871471c6f54e08c633e6c203a48927"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0e7a88246c74ce7e959c30a8c4bc757c2bfcb46faa1fcd4a4bc745a4ed8fd15f"
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
