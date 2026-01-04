class Wifitui < Formula
  desc "Pretty feed reader (ATOM/RSS) that stores articles in Markdown files"
  homepage "https://github.com/shazow/wifitui"
  url "https://github.com/shazow/wifitui/archive/refs/tags/v0.10.0.tar.gz"
  sha256 "2e5e565eaad529b769dc2f558256c7a0aa51bdf4c1baea4353f9e533799395f8"
  license "MIT"
  head "https://github.com/CrociDB/bulletty.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "58a37318b1d1b42fef00624ec1accd3e5bfd47a6b50ba4149516141cd0732a2e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "58a37318b1d1b42fef00624ec1accd3e5bfd47a6b50ba4149516141cd0732a2e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "58a37318b1d1b42fef00624ec1accd3e5bfd47a6b50ba4149516141cd0732a2e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "643013c7b1132eeb35badf844d4585a59207025a20045ab85a8b9b25c0df2246"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "54c86ef265c3d5c192d58c5789d264f57c48f6989915995a36cfac4fde932527"
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
