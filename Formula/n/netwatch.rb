class Netwatch < Formula
  desc "Real time network diagnostics in your terminal"
  homepage "https://github.com/matthart1983/netwatch"
  url "https://github.com/matthart1983/netwatch/archive/refs/tags/v0.35.3.tar.gz"
  sha256 "27cfa869f22d903e40b481ab61a60a9679afccbee5b622439243be4ebf722958"
  license "MIT"
  head "https://github.com/matthart1983/netwatch.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "bbd8e8fb5a123eb62e82f16fbd357554942b8c6a540b0bb7847accb1f9d822ff"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1e23ef105d1fc46c8871d633675ecc4e75979815820e5bd028346828eab5b242"
    sha256 cellar: :any,                 arm64_linux:   "dd115cb9f696d4e6081878a45849f1d3221780b33c07c2c2131c1729045fe8e8"
    sha256 cellar: :any,                 x86_64_linux:  "175635c5fdc8fe100d945a36d4cf564a3678e77b2afd874810b79bc1dc212b72"
  end

  depends_on "rust" => :build
  uses_from_macos "libpcap"

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/netwatch --version")

    output = shell_output("#{bin}/netwatch --generate-config")
    assert_match "Config written to", output
  end
end
