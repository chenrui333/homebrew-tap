class Pphack < Formula
  desc "Client-Side Prototype Pollution Scanner"
  homepage "https://github.com/edoardottt/pphack"
  url "https://github.com/edoardottt/pphack/archive/refs/tags/v0.1.2.tar.gz"
  sha256 "c279f74de81f00afd004337aa79d0508655ab26ddb7b3094a70398bc78a8da58"
  license "MIT"
  head "https://github.com/edoardottt/pphack.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "59b2095ebc7d02903f5583746b8514135a35eaa32d3a0c6e719094f9210fd316"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "59b2095ebc7d02903f5583746b8514135a35eaa32d3a0c6e719094f9210fd316"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "59b2095ebc7d02903f5583746b8514135a35eaa32d3a0c6e719094f9210fd316"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b7c6fae4bd4e5cf5f960e5930fe0d737e953623989080da8cc7bcbec8423269e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "23fcdc50a52841c6e4ff9847e204223bd950b17e2b0e8dafd164d3ceb8f382ea"
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
