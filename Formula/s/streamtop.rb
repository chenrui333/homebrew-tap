class Streamtop < Formula
  desc "Terminal monitor for HLS, DASH and IPTV streams"
  homepage "https://github.com/Jorji49/streamtop"
  url "https://github.com/Jorji49/streamtop/archive/refs/tags/v1.5.2.tar.gz"
  sha256 "ddaec44657109ab228cfbc7d064331882d36281f026f6e624eb985c334167d78"
  license "MIT"
  head "https://github.com/Jorji49/streamtop.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "90756bcaa60ae78a35cf08c3e6aa0216a1b9fe03e5f1e1cc150e30dd428f8f2a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d7935482ed0ab3a9555bcf251927577d415b0726410d23c551d1c16e4a46357e"
    sha256 cellar: :any,                 arm64_linux:   "1dca170ee74a61c43ee9fa5d8980d34d526b12ae33ac8f010f3f0680674d9a81"
    sha256 cellar: :any,                 x86_64_linux:  "16d31b3090adc403d4eb7c931f7bf6b519e9500ae7129051f70e0c629931e915"
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
