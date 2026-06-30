class Multica < Formula
  desc "Open-source managed agents platform for AI coding agents"
  homepage "https://github.com/multica-ai/multica"
  url "https://github.com/multica-ai/multica/archive/refs/tags/v0.3.33.tar.gz"
  sha256 "d2d28e0565f9b1a70abbb6891d146f2b729e52216823edf8e8b072891e11d388"
  license :cannot_represent
  head "https://github.com/multica-ai/multica.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "af465dea607494d7a7ec8ffdd55b78aa6bec457be3bb678ace0350cb2063b54d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "af465dea607494d7a7ec8ffdd55b78aa6bec457be3bb678ace0350cb2063b54d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "af465dea607494d7a7ec8ffdd55b78aa6bec457be3bb678ace0350cb2063b54d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1feb0e5e299cec6e8c5fc1f0428e8d4a5ef81c9607dbefeaa19f0f0654318817"
    sha256 cellar: :any,                 x86_64_linux:  "33477b06bd30dd519edf50adae5e1e8f28abdd643b2725181782cd66837a15f5"
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
