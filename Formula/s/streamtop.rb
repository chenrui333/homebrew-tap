class Streamtop < Formula
  desc "Terminal monitor for HLS, DASH and IPTV streams"
  homepage "https://github.com/Jorji49/streamtop"
  url "https://github.com/Jorji49/streamtop/archive/refs/tags/v1.5.4.tar.gz"
  sha256 "b70558df2263772eec644923116797724bc804951e0c04fb96d781bf0c8d69fe"
  license "MIT"
  head "https://github.com/Jorji49/streamtop.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fecbe2ca068e21feb905639083f9206abaadb68e16c833eb3ec0c51961c217f0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "dec0fcd57a81844584315437d8ce87ae86058818c05c09cb99b0189783c22226"
    sha256 cellar: :any,                 arm64_linux:   "3259ce58672cd1841b3b0eaac99521bc5c7ce76b8c24636532a96f87fe77c1dd"
    sha256 cellar: :any,                 x86_64_linux:  "81df70ddbbdb56ecce5867ac7c0016add71ef9b0cd6c2bb5dfb362412f45a6f4"
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
