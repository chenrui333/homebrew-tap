class Netwatch < Formula
  desc "Real time network diagnostics in your terminal"
  homepage "https://github.com/matthart1983/netwatch"
  url "https://github.com/matthart1983/netwatch/archive/refs/tags/v0.32.3.tar.gz"
  sha256 "f91dfa39c0cf0dd721d5f8ec82bac46666c3ec2be1eb234b00b7524bc58122ba"
  license "MIT"
  head "https://github.com/matthart1983/netwatch.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1e97172f180652bdad094b1656f9cbde5d724c6fd8dbf95f95abd0387a570ea8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "20073256e0573f2cffd1da51b459566fd6ad4bc03ea745fb82932212821c550f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7052c45233e8c86a2187002c685e135c19cb33db8b89fda0696d9963305a2d6c"
    sha256 cellar: :any,                 arm64_linux:   "5fd37acd45eb5d300f4ae92668ed453264c8e19a7fab319db5523524d569429e"
    sha256 cellar: :any,                 x86_64_linux:  "497b3caac59da25b018295cba72535c0153703cedbc62c82faf731d7232fb4bd"
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
