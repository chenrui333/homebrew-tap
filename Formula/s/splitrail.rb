class Splitrail < Formula
  desc "Real-time token usage tracker and cost monitor for CLI coding agents"
  homepage "https://splitrail.dev/"
  url "https://github.com/Piebald-AI/splitrail/archive/refs/tags/v3.6.0.tar.gz"
  sha256 "9d91468a62f688c638d961f5f1b8c0ec991fd20a2ee5d74e68c5a69f23c31aca"
  license "MIT"
  head "https://github.com/Piebald-AI/splitrail.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4f44965e57b6d6b3649d4238b24c41d1b905a4e268159e6cc89e64fabdca4943"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6fe0e345fde9d5fcbaa0cddca7749d71da709cb6ff65d1a764d188d5bf345464"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "410dad06f1863b04f3a72def3a17d2f4f541190906efa08d2bad695c98223628"
    sha256 cellar: :any,                 arm64_linux:   "29aa44fbc2b4883a239f80da117acec54cea7220e732e517377c7745e5a83fd7"
    sha256 cellar: :any,                 x86_64_linux:  "134e354c38c49b557bd5512db7f4b504f061fa7c50ae6325823f0b8ef076aa8c"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/splitrail --version")

    output = shell_output("#{bin}/splitrail config init")
    assert_match "Created default configuration file", output
    assert_match "[server]", (testpath/".splitrail.toml").read
  end
end
