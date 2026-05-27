# frozen_string_literal: true

class Fakecloud < Formula
  desc "Free, open-source local AWS cloud emulator for integration testing"
  homepage "https://github.com/faiscadev/fakecloud"
  url "https://github.com/faiscadev/fakecloud/archive/refs/tags/v0.15.2.tar.gz"
  sha256 "85abbe77dcd78fa143e1b19981e215fb39687036f0570f45a4261038ec3f7453"
  license "AGPL-3.0-or-later"
  head "https://github.com/faiscadev/fakecloud.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f051fdc6be05537ec7bf490aacbfc0cc3b410efbc35b5c472454ace7203af301"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "71d4e8dfb2620016605ebe39ef0a4ac11d9dcb2aabd909447fd82ef61e8bc8c0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7a2ca4b295ccf86d95963a35770484ed83a53dc34fc141a5609ce09eaa026009"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ac174a5d486ce9ea1402b9d746ebc51f9dcc113dda3922448191b5fda74aa409"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ca08d0692323b921d793bb6b9b3a5a1c8bb489df00106ebd1e6c19e2f3e2c107"
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
