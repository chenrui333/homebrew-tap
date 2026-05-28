# frozen_string_literal: true

class Fakecloud < Formula
  desc "Free, open-source local AWS cloud emulator for integration testing"
  homepage "https://github.com/faiscadev/fakecloud"
  url "https://github.com/faiscadev/fakecloud/archive/refs/tags/v0.15.3.tar.gz"
  sha256 "6cb7b99daf2ce787fd743aed25138fbf7004d82cb504f1a597b5698a11b265c4"
  license "AGPL-3.0-or-later"
  head "https://github.com/faiscadev/fakecloud.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fc590a942e5aa1dc5c8eef31ff39acd6226a1aca81246664f026f39da760a0ef"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0292fc762d04cea900652ff9a360a0db0c48e9495f43fde9d6b3bd16869776ea"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cd8e9d8d6c8c0b2e7b9decfe2eaad301386ea9a9ca064c8a103cbe6805ecb299"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c5419750ba05a15c721a69f0d588a6f1ba74fab9187c2cd9c8fcff1812305325"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "181e72ef0277987dfa2b2476d6bd646817eb3939164ea546f427a4d9a3583bce"
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
