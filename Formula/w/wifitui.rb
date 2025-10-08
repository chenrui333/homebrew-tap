class Wifitui < Formula
  desc "Pretty feed reader (ATOM/RSS) that stores articles in Markdown files"
  homepage "https://github.com/shazow/wifitui"
  url "https://github.com/shazow/wifitui/archive/refs/tags/v0.4.2.tar.gz"
  sha256 "7705cc20e2f4a59418750e4ee51ddb2e475b902315bce6022230c3c31d1cf4c8"
  license "MIT"
  revision 1
  head "https://github.com/CrociDB/bulletty.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "dc27bb1c347a79e166d321d5c0593d93b57e93b5f69492b0a51fde0bf7636b3c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5cd68c66bc6a8be23a06c8b2edcbe9cb75fcdfbb7d766bc5591bceabc6b72ce4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2a646bab1acc2cc8dd3bdd73d71cecdceb477e49067c634a6507725382c43d2c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "af74bd444d043a8affdd271abd3ff9873e84a6b63bf9414707cb4496bda42b8a"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.Version=#{version}")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/wifitui --version")

    expected = OS.mac? ? "no Wi-Fi interface found" : "failed to list networks"
    assert_match expected, shell_output("#{bin}/wifitui list 2>&1", 1)
  end
end
