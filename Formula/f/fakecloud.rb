# frozen_string_literal: true

class Fakecloud < Formula
  desc "Free, open-source local AWS cloud emulator for integration testing"
  homepage "https://github.com/faiscadev/fakecloud"
  url "https://github.com/faiscadev/fakecloud/archive/refs/tags/v0.15.1.tar.gz"
  sha256 "9a1202e8da1ddac56c6b0b45163cb8ecc37534d1eb891ad3be1ebd7408d7b5ce"
  license "AGPL-3.0-or-later"
  head "https://github.com/faiscadev/fakecloud.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "600b76f76b6f3ede3579a6ad8a5d5bae445618ac9aa3078f46a26eaf2f46a579"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "aca3d90b33875f7e122706065cc181c64b463c9502640fe4f8815d10062f94a0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c066b1d1719f3c3cc39cd8204a081d75311c91975feb7f5b07c2bf128307c1e3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d6afb76deb9cf79d251725fb95af7d992ee4e713b153fa16bd09f2a8dbd88964"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7aa91b77481d61bf9ef99f8534df1e353496beb65e0cb97dbd59cf1de554f30b"
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
