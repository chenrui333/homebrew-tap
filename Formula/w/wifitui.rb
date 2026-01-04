class Wifitui < Formula
  desc "Pretty feed reader (ATOM/RSS) that stores articles in Markdown files"
  homepage "https://github.com/shazow/wifitui"
  url "https://github.com/shazow/wifitui/archive/refs/tags/v0.10.0.tar.gz"
  sha256 "2e5e565eaad529b769dc2f558256c7a0aa51bdf4c1baea4353f9e533799395f8"
  license "MIT"
  head "https://github.com/CrociDB/bulletty.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e179b500b7364740d78bffa758b0c622fbb13511c9d07d0124af266a25cc9ac3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e179b500b7364740d78bffa758b0c622fbb13511c9d07d0124af266a25cc9ac3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e179b500b7364740d78bffa758b0c622fbb13511c9d07d0124af266a25cc9ac3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "27dcf58e310ab29948c3ad2f6f222dcd3fec0b64d1b10e9656255d003c9b5ad9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "488bf347d8eb7714cc09e6a8eacac7947556e00d45eaa04c0742fbf647b7755e"
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
