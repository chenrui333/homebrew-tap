class Gorae < Formula
  desc "TUI librarian for PDFs and EPUBs"
  homepage "https://github.com/Han8931/gorae"
  url "https://github.com/Han8931/gorae/archive/refs/tags/v2.1.0.tar.gz"
  sha256 "97ed392e698bce035c633b472fd2ca356274297b3c4bb44bb363278aec0d3469"
  license "MIT"
  head "https://github.com/Han8931/gorae.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4e4fdbab1d38bbebbbae3a5f389c98fd5cfbb4a45569492d391adde0ca8aed1f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4e4fdbab1d38bbebbbae3a5f389c98fd5cfbb4a45569492d391adde0ca8aed1f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4e4fdbab1d38bbebbbae3a5f389c98fd5cfbb4a45569492d391adde0ca8aed1f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "651d1b4039b404dd25e94f89ee431f8dd7887a187ae4fcc152b2005aacbcf687"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "606b73622ca14408dba328fbcb334593c2a03b5b435b93dfe946b7faaadcc220"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/gorae"
  end

  test do
    assert_match "Root directory to start in", shell_output("#{bin}/gorae --help 2>&1")
  end
end
