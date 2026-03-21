class Pwdsafety < Formula
  desc "CLI checking password safety"
  homepage "https://github.com/edoardottt/pwdsafety"
  url "https://github.com/edoardottt/pwdsafety/archive/refs/tags/v0.4.2.tar.gz"
  sha256 "6676f7ccc1ad32e8c68b889426b563d69080a69c1f9212b32d79fccc2e70b79f"
  license "GPL-3.0-only"
  head "https://github.com/edoardottt/pwdsafety.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "704a29e204a3ef89a534dfcbabb794b9172196afee42471bcd6c6f5098258be9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "704a29e204a3ef89a534dfcbabb794b9172196afee42471bcd6c6f5098258be9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "704a29e204a3ef89a534dfcbabb794b9172196afee42471bcd6c6f5098258be9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e23248ca2f5ff39e154f40de309c6a1f985eb730401d372bdb93ebad3d830911"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9cc85f8c575b9e4853a99e0ea07197a2cec7d1e57e0720db9060b6f2bafcb30e"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/pwdsafety"
  end

  test do
    output = pipe_output("#{bin}/pwdsafety 2>&1", "123\n", 1)
    assert_match "Hey....Do you know what password cracking is?", output
  end
end
