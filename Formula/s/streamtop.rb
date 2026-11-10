class Streamtop < Formula
  desc "Terminal monitor for HLS, DASH and IPTV streams"
  homepage "https://github.com/Jorji49/streamtop"
  url "https://github.com/Jorji49/streamtop/archive/refs/tags/v1.8.0.tar.gz"
  sha256 "b23414140a842a67b5c36a27e9c1ddc05d1c08dc010b0be996f5be9b08c30865"
  license "MIT"
  head "https://github.com/Jorji49/streamtop.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1f4133149bd4998ea55ff67e24b0642b3ace1ddb130378b68eaf7676bf7049b5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "451f5ebed47fe47813adb5bad6e1499155f94f9e4233a7a6a6ee34d25090a4be"
    sha256 cellar: :any,                 arm64_linux:   "f364abf923b0d84ec16a368346c973a8a15e17cb876fcf28f0a91ffe816f79a3"
    sha256 cellar: :any,                 x86_64_linux:  "617e9302692a09855bfb435183ca370e62b893ac0af9f6ec88933e2db7ad8e38"
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
