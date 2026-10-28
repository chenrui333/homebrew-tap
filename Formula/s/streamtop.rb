class Streamtop < Formula
  desc "Terminal monitor for HLS, DASH and IPTV streams"
  homepage "https://github.com/Jorji49/streamtop"
  url "https://github.com/Jorji49/streamtop/archive/refs/tags/v1.5.4.tar.gz"
  sha256 "b70558df2263772eec644923116797724bc804951e0c04fb96d781bf0c8d69fe"
  license "MIT"
  head "https://github.com/Jorji49/streamtop.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "eab3dc423c13d89f2874ad80366ab528dbba4e19169d0f8401ebd7f950cd5eed"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3d7554af50b7c145b16bedc9488e9d07a36d601fa1a81337d78706944acdf954"
    sha256 cellar: :any,                 arm64_linux:   "7951d7631782568f57f48fa15b4c3f5655b5b842bccb98175da56a161e3b07c7"
    sha256 cellar: :any,                 x86_64_linux:  "e6981c1d75bc24e04d22ea77ad4f3616d554e20417b3a084d97b180f515700d3"
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
