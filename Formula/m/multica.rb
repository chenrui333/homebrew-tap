class Multica < Formula
  desc "Open-source managed agents platform for AI coding agents"
  homepage "https://github.com/multica-ai/multica"
  url "https://github.com/multica-ai/multica/archive/refs/tags/v0.4.12.tar.gz"
  sha256 "c824e178bbe52004ee92f01a064d5b6080b993f2271f5665b90f608544704c6f"
  license :cannot_represent
  head "https://github.com/multica-ai/multica.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a6d40b6bd507a56b0972b974cb557d527448690ac6180bf7e96b0b91d4cd3c93"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a6d40b6bd507a56b0972b974cb557d527448690ac6180bf7e96b0b91d4cd3c93"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a6d40b6bd507a56b0972b974cb557d527448690ac6180bf7e96b0b91d4cd3c93"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "48dfed5999b76aaec19d7f5f9798289fe5ed63e6379fe1a3e0611d8146445c33"
    sha256 cellar: :any,                 x86_64_linux:  "125d7f0e8ca5c38816c1c83b91ab7b4fa362fda49e56b82d730935774adf198d"
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

    system bin/"multica", "config", "set", "server_url", "https://example.com"
    assert_match(%r{^server_url:\s+https://example\.com$}, shell_output("#{bin}/multica config show"))
  end
end
