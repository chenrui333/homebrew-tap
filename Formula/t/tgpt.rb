class Tgpt < Formula
  desc "AI Chatbots in terminal without needing API keys"
  homepage "https://github.com/aandrew-me/tgpt"
  url "https://github.com/aandrew-me/tgpt/archive/refs/tags/v2.9.1.tar.gz"
  sha256 "05c2d2009789679fe1d744474783a853abc79d3dad6d14871402ee933397fe00"
  license "GPL-3.0-only"
  head "https://github.com/aandrew-me/tgpt.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "12948713931a6b14b12dcd70a27aafcf27bcf4a80da3c30c853b1c9e61369523"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4805c0324d35b1b0ada50f5bdb5ffc63697956751067d1d06e3a457894f74e9d"
    sha256 cellar: :any_skip_relocation, ventura:       "39491179bbc26fe5815bfab816f87e1e38513b5bc3d39cca9feb5ad1159a3961"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6d72ad7abdbe1508f017d3f0b636c2db33ae492365a073fe947dd45a6f500a59"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/tgpt --version")

    output = shell_output("#{bin}/tgpt --provider duckduckgo \"What is 1+1\"")
    assert_match "1 + 1 equals 2.", output
  end
end
