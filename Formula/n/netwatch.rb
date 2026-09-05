class Netwatch < Formula
  desc "Real time network diagnostics in your terminal"
  homepage "https://github.com/matthart1983/netwatch"
  url "https://github.com/matthart1983/netwatch/archive/refs/tags/v0.30.0.tar.gz"
  sha256 "95dfbbf1208806d383bf8309ff40ec29fc55e1081ecd7c41ee8f110c8aa32227"
  license "MIT"
  head "https://github.com/matthart1983/netwatch.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a7ed2c66a86350ed7908062a8df1d14ee263fd2bfb4dfebcbaf9809d67b5b97e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "49ec07ef66cf9ae833bd92148488db22704bc02330850c97a88eae81c9b9f4e7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c444cbae51158314565be7dc71a097e41dfc2ed42755661abeba948ebd69426d"
    sha256 cellar: :any,                 arm64_linux:   "eede8d39578d5656bf5b8651cb102b1262f903090c2b1c690fc56d3f33d99282"
    sha256 cellar: :any,                 x86_64_linux:  "fdd791b0b0538030da46b7b68639728b09e9aaf22f69327d80d4e6c51ac1e510"
  end

  depends_on "rust" => :build
  uses_from_macos "libpcap"

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/netwatch --version")

    output = shell_output("#{bin}/netwatch --generate-config")
    assert_match "Config written to", output
  end
end
