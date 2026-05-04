class Pphack < Formula
  desc "Client-Side Prototype Pollution Scanner"
  homepage "https://github.com/edoardottt/pphack"
  url "https://github.com/edoardottt/pphack/archive/refs/tags/v0.1.4.tar.gz"
  sha256 "db0c06eef491cf689cd0d1b683ea47bf5c79dfc664413cccdccda263d7fcf5c3"
  license "MIT"
  head "https://github.com/edoardottt/pphack.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "636d8421dd4ec72791ba83f3c5531df1706e3df6e6f92d0a17209cb612b86de2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "636d8421dd4ec72791ba83f3c5531df1706e3df6e6f92d0a17209cb612b86de2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "636d8421dd4ec72791ba83f3c5531df1706e3df6e6f92d0a17209cb612b86de2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8b4700ade4d3ea1d1b2d08bf7ad25b21dfbe9bacb1fc0734a5bb217bb372a068"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ac9c9c3d67cd5b41adf1f1445313cefabed7a310f0b515270174ff132e9bdaf7"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/pphack"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/pphack -help")
    # output = shell_output("#{bin}/pphack -u https://edoardottt.github.io/pphack-test/")
    # assert_match "[VULN]", output
  end
end
