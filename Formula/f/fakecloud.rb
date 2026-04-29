# frozen_string_literal: true

class Fakecloud < Formula
  desc "Free, open-source local AWS cloud emulator for integration testing"
  homepage "https://github.com/faiscadev/fakecloud"
  url "https://github.com/faiscadev/fakecloud/archive/refs/tags/v0.13.3.tar.gz"
  sha256 "458aa0b837f6ae5e2822453701d6df283ea321a5ec43113f8371eb25d1dfb0d2"
  license "AGPL-3.0-or-later"
  head "https://github.com/faiscadev/fakecloud.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a1424132668b7aa35b0dd41dd2530fa9e9a52da0ad37b6527418188969788eeb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f12d02f5bf79bdeef9d648b0e5ab93ed1a8456c91bd00e3afdffcea1cd1d7268"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "405e1489c2a8a1114e998aa7a4c5b3c391008da1bfbe62c5585b94bba121ab6a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b101fb7e18a5452ee52147c9124687710f898cf95a65f6c4798277b2387c918b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f1108a49e39245b8da4754e89ef95993b8051669d9fddba315ebba3ced241563"
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
