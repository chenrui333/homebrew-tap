# frozen_string_literal: true

class Fakecloud < Formula
  desc "Free, open-source local AWS cloud emulator for integration testing"
  homepage "https://github.com/faiscadev/fakecloud"
  url "https://github.com/faiscadev/fakecloud/archive/refs/tags/v0.17.0.tar.gz"
  sha256 "3fd6e838d92df4ddaedbd79f8bf7d6aa677c1f7fb1e51c4ce02185061d57133b"
  license "AGPL-3.0-or-later"
  head "https://github.com/faiscadev/fakecloud.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c0191b2f79c8e8334a88bdc473424cb69030f8290bbb0ead161966d60cdd8c64"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "564e6ddd26db232028c503ffd9899593cc2ca264a245830ad9bad6f911c45d9a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4f7d7216cc5b73331f53f187f7440bfff9f1ad7a870531ace88b397cc91314b9"
    sha256 cellar: :any,                 arm64_linux:   "13a96308bb8a49f79cab385624480aacc336c5bcf620828f2a00e9e7945f1939"
    sha256 cellar: :any,                 x86_64_linux:  "7041e5835058d9d516c879938b675c38bc0d96144a3c54a09501907aa2cbe8a9"
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
