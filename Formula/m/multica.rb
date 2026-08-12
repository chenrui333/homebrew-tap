class Multica < Formula
  desc "Open-source managed agents platform for AI coding agents"
  homepage "https://github.com/multica-ai/multica"
  url "https://github.com/multica-ai/multica/archive/refs/tags/v0.4.24.tar.gz"
  sha256 "b73b9049c0a0dfd8f62461e3de0d59f61f116b0f76401c0122a32feed67277d5"
  license :cannot_represent
  head "https://github.com/multica-ai/multica.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "cf4cb9fc9b17abc26c256e11e404bf18e6c688189cb759613bf1074d59514120"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cf4cb9fc9b17abc26c256e11e404bf18e6c688189cb759613bf1074d59514120"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cf4cb9fc9b17abc26c256e11e404bf18e6c688189cb759613bf1074d59514120"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b0f891738b1d5b6da46b3c3695ecf18ccda0823705ec76127ffe915f19423c4f"
    sha256 cellar: :any,                 x86_64_linux:  "f7d3e902968fd62ee75534fe448d2417f52cbaf13dd06e048e4ee7eca09999af"
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
