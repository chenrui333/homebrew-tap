class Wifitui < Formula
  desc "Pretty feed reader (ATOM/RSS) that stores articles in Markdown files"
  homepage "https://github.com/shazow/wifitui"
  url "https://github.com/shazow/wifitui/archive/refs/tags/v0.8.0.tar.gz"
  sha256 "4d2d8ea402c61837d94145c10dc5d64366dbfbc862747d49f993bb41803c3711"
  license "MIT"
  head "https://github.com/CrociDB/bulletty.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8d7905bc93b3f7ac6f88727c6e6d6f99cc49099798da5d914da48ab88ba3e63f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8d7905bc93b3f7ac6f88727c6e6d6f99cc49099798da5d914da48ab88ba3e63f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8d7905bc93b3f7ac6f88727c6e6d6f99cc49099798da5d914da48ab88ba3e63f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "494e72e4935f969f1f39e5a3b91e288d29b4303a65c7905f259f5c9237a2843e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4cd021b240ce2121d3bdb14cca5eaf151bdaaaeea9acde20f7f96161e75060ec"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.Version=#{version}")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/wifitui --version")

    expected = OS.mac? ? "no Wi-Fi interface found" : "connect: no such file or directory"
    assert_match expected, shell_output("#{bin}/wifitui list 2>&1", 1)
  end
end
