class Streamtop < Formula
  desc "Terminal monitor for HLS, DASH and IPTV streams"
  homepage "https://github.com/Jorji49/streamtop"
  url "https://github.com/Jorji49/streamtop/archive/refs/tags/v1.5.2.tar.gz"
  sha256 "ddaec44657109ab228cfbc7d064331882d36281f026f6e624eb985c334167d78"
  license "MIT"
  head "https://github.com/Jorji49/streamtop.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d16ce658fa134a0edde4baf4d22719aaaf953b7f87d6e242b24718af7a3ecc4b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f7d60f8aee5368375bcde29c91c26d8096d3dde8827468c452f9add4e026e482"
    sha256 cellar: :any,                 arm64_linux:   "70ef3a391882dad8a82b2453828a1318928672e41b18b515831469aec2c47d5a"
    sha256 cellar: :any,                 x86_64_linux:  "23e26c055085eae3e3d6f37a033bafb9c5a000e21d4630a2c096ea7cd7362e8f"
  end

  depends_on "rust" => :build

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
