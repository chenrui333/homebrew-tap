class Multica < Formula
  desc "Open-source managed agents platform for AI coding agents"
  homepage "https://github.com/multica-ai/multica"
  url "https://github.com/multica-ai/multica/archive/refs/tags/v0.3.15.tar.gz"
  sha256 "b854049ce4bc19c9eb28da978d1bd8d22b067737d01c99caaa4d5412bce76950"
  license :cannot_represent
  head "https://github.com/multica-ai/multica.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8d81c9a70926af8c945cbbec6a72128920b83b9b7ea5b933ad917f2ca2529619"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8d81c9a70926af8c945cbbec6a72128920b83b9b7ea5b933ad917f2ca2529619"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8d81c9a70926af8c945cbbec6a72128920b83b9b7ea5b933ad917f2ca2529619"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f46059cd0e203032830689aa7349dae668dcc544d8ae18eb48cad881c95f14a7"
    sha256 cellar: :any,                 x86_64_linux:  "e335e98846cf66698b099ba95949827c0f3c128361329fa66f0dc23527e8837e"
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
