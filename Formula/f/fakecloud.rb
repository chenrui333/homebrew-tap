# frozen_string_literal: true

class Fakecloud < Formula
  desc "Free, open-source local AWS cloud emulator for integration testing"
  homepage "https://github.com/faiscadev/fakecloud"
  url "https://github.com/faiscadev/fakecloud/archive/refs/tags/v0.15.4.tar.gz"
  sha256 "a48dbf2f34377890b5913c43db39bdd5fbba79174e4c977dcacdc3ac0ea0b41d"
  license "AGPL-3.0-or-later"
  head "https://github.com/faiscadev/fakecloud.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "af985ece1965896103e61ecefba1b3b70e80700aee766a82094639ce60053f45"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0da8bea734ce673574bcd461cbc23449580ab1be8913eb0a22bf7dd6e155cd01"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8fb99222e5482fc848034ac996ded83ce091ff45d900dd3dd7933602d66672c9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b25667c8b1133d231c2ae5921dbf8b3e48c57e989f39f7bcd20a1aa67f92b3c2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0be0031f5474456d2dd0ccdd2be07a111d1f8323f46e11d36783126b435b9da0"
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
