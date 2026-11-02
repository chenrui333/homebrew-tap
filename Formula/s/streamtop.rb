class Streamtop < Formula
  desc "Terminal monitor for HLS, DASH and IPTV streams"
  homepage "https://github.com/Jorji49/streamtop"
  url "https://github.com/Jorji49/streamtop/archive/refs/tags/v1.7.1.tar.gz"
  sha256 "73098f853919714fcb508517d342b2c5122b5ef248bbd19a03205fb460c606e2"
  license "MIT"
  head "https://github.com/Jorji49/streamtop.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "03251e20aa1009c3bea7d8551cfae503e02d2f737f6f97f54f502e888406dc93"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "64cb273ea111a1ac9cad696dfb010320ee11e64a4c7f811275f30e25ddc49606"
    sha256 cellar: :any,                 arm64_linux:   "75d684fa955cc3fba86df9c79079aecfb5cc381084e55199242088b39bbfd5fe"
    sha256 cellar: :any,                 x86_64_linux:  "9c3f392879c0fcbb113a16bc1ed7ae85e550dccc7b2cafbfc2ebbcf10e36cd40"
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
