class Multica < Formula
  desc "Open-source managed agents platform for AI coding agents"
  homepage "https://github.com/multica-ai/multica"
  url "https://github.com/multica-ai/multica/archive/refs/tags/v0.3.17.tar.gz"
  sha256 "0f6264d9cfad8fc0ebd8fa744ef7fc7445ccd60a55593ff6d9629fade404e2fe"
  license :cannot_represent
  head "https://github.com/multica-ai/multica.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a480a39e8c8ed12e464425d5f11bd7a11e6bf227a66826aa5493635562c5e592"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a480a39e8c8ed12e464425d5f11bd7a11e6bf227a66826aa5493635562c5e592"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a480a39e8c8ed12e464425d5f11bd7a11e6bf227a66826aa5493635562c5e592"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0d61647df2c041a711c48688301113b26d6d982e2bc24534e7c1fd33bf4d02f3"
    sha256 cellar: :any,                 x86_64_linux:  "039a3cb35791fea3eae13dcda1ab56b95fce827267d8ae454c31a2de8508ddcf"
  end

  depends_on "go" => :build

  def install
    cd "server" do
      ldflags = %W[
        -s -w
        -X main.version=#{version}
        -X main.commit=#{tap.user}
        -X main.date=#{time.iso8601}
      ]
      system "go", "build", *std_go_args(ldflags:), "./cmd/multica"
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/multica version")
  end
end
