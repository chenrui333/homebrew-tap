class Multica < Formula
  desc "Open-source managed agents platform for AI coding agents"
  homepage "https://github.com/multica-ai/multica"
  url "https://github.com/multica-ai/multica/archive/refs/tags/v0.3.11.tar.gz"
  sha256 "c951e51b9076f3b0c584a6a61dc049e37c2efcaea8c5bdb32d16fb170b7e0621"
  license :cannot_represent
  head "https://github.com/multica-ai/multica.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f3bff02af4931ac651903b5451c6ad1d444c0ad25fd0ce22c2531e1656ccd302"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f3bff02af4931ac651903b5451c6ad1d444c0ad25fd0ce22c2531e1656ccd302"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f3bff02af4931ac651903b5451c6ad1d444c0ad25fd0ce22c2531e1656ccd302"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5113a134f566047141f7065cf0701ffccfb9c5aaa3112b25f250936fa462598d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7ae426d0f927671375209393e04fda9fe43c71d574a9438d5aa2a01a0e9b0b29"
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
