class Streamtop < Formula
  desc "Terminal monitor for HLS, DASH and IPTV streams"
  homepage "https://github.com/Jorji49/streamtop"
  url "https://github.com/Jorji49/streamtop/archive/refs/tags/v1.7.1.tar.gz"
  sha256 "73098f853919714fcb508517d342b2c5122b5ef248bbd19a03205fb460c606e2"
  license "MIT"
  head "https://github.com/Jorji49/streamtop.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4b1e0d29171bcd8e0c2bff59aa0215cdadc0507b121d4ee5503a54285d4351a3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c63a9051e5ecb93c71c1814321e06fe789fcd9d3b1fb667b61350293fdfa4d8f"
    sha256 cellar: :any,                 arm64_linux:   "840cb89b6768b10a4f5ee158cb9d27318b3927b19d1461821b8b75a0ce21a192"
    sha256 cellar: :any,                 x86_64_linux:  "dc62ffb5c796984ab20b15f2dc3543f7553672e0b78fabebd7dca7a01c512241"
  end

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  service do
    run [opt_bin/"streamtop", "--agent", etc/"streamtop.toml"]
    log_path var/"log/streamtop.log"
    error_log_path var/"log/streamtop.log"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/streamtop --version")
    (testpath/"empty.toml").write("streams = []\n")
    output = shell_output("#{bin}/streamtop --agent #{testpath}/empty.toml 2>&1", 1)
    assert_match "agent config has no [[streams]] entries", output
  end
end
