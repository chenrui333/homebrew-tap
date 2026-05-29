# frozen_string_literal: true

class Fakecloud < Formula
  desc "Free, open-source local AWS cloud emulator for integration testing"
  homepage "https://github.com/faiscadev/fakecloud"
  url "https://github.com/faiscadev/fakecloud/archive/refs/tags/v0.16.0.tar.gz"
  sha256 "7c12476933ce182543b58dbe7df7792aa05b06d310f354c9f2c2038dc0b137f5"
  license "AGPL-3.0-or-later"
  head "https://github.com/faiscadev/fakecloud.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5e23e5859b6bd88e90cb5a867e022fa47c51b61907ddafb866cf6918204ca99f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7d52e80b2cdaec7050fb7b130b9da9aeb4e70eed96970cf0ad2df8c6360ce0b2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "62b29e4de0595ed9b8ba6a1e68d9f5f0ed8db2ef3738c28ef6fede34db03b3f6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "63c0c7e3bf1cf7528a4e2cfb274e0755a24e7b4f101af5d23f383474576501d0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "38fae18d4b4a84b07c2317d7bb5a14ee018694f924172b6605c4da7374be90e7"
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
