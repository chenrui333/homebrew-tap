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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b7174be903500c7d0d8afac17b5c862b1dd211cc5851c291fefb113c04fd4a1a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e541f5ab6d2cce8c30d2a730468ff69868118fd273d23a95c756e7cb6edc4ec8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fca204912c7abda07db5f233aae815e32e4b302107736262a7a18705d3c8c18e"
    sha256 cellar: :any,                 arm64_linux:   "c2686411004981201b8c2eb79c7b69b674dd0b9fbcc23b204cfd681d2cad2a0c"
    sha256 cellar: :any,                 x86_64_linux:  "42b0d4aa5b2ee5222748070200cfae79f1e90c59a1af5ab629d0efbf07670148"
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
