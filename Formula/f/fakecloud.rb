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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "37c9c51d1a4ecc466f37075e3a2a77032519422273f8127e355b43aeceb91528"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "af8fce9158c3287b2c5df059f8a6c0ea42f4773064580ce709ad537ac2e1e637"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e72a1f26142972820e8caa4b41094bba0218c1f35b597662b93fb54815a5215a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "65bd91bf79f5f1dda66c36adc7d30465257b8e82d9876bbe48181a21f0d459bf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7e6f50fc4389884671e0783f4828a5d06597d7038e44474425eb9bdece3963ee"
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
