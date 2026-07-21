class Multica < Formula
  desc "Open-source managed agents platform for AI coding agents"
  homepage "https://github.com/multica-ai/multica"
  url "https://github.com/multica-ai/multica/archive/refs/tags/v0.4.7.tar.gz"
  sha256 "86adf489bcf6298e51a7480a2437b620e9679911cb3491fb1506bdfd775a5eb2"
  license :cannot_represent
  head "https://github.com/multica-ai/multica.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6e765dcf8e35de6508fac2b0b5d17df26014e0f095c59d1e813d68d7a9bac14e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6e765dcf8e35de6508fac2b0b5d17df26014e0f095c59d1e813d68d7a9bac14e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6e765dcf8e35de6508fac2b0b5d17df26014e0f095c59d1e813d68d7a9bac14e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "404259e25aad2958d51e59bb780c5f843ceb6e360ae414cf6c83216cff1b7b38"
    sha256 cellar: :any,                 x86_64_linux:  "7329a8c3bd31af476597f4cc3566715659b426b8efed6aace44791ab61862b20"
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
