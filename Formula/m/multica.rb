class Multica < Formula
  desc "Open-source managed agents platform for AI coding agents"
  homepage "https://github.com/multica-ai/multica"
  url "https://github.com/multica-ai/multica/archive/refs/tags/v0.3.29.tar.gz"
  sha256 "9a76287c194c5d8f6c7e4a9f161d736683e3a12554d483f355c939985d6fc317"
  license :cannot_represent
  head "https://github.com/multica-ai/multica.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "bfc0a985f2efe703a5f3de5e132c93e5ddd9f99454a9a37c636d2575948b4bd9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bfc0a985f2efe703a5f3de5e132c93e5ddd9f99454a9a37c636d2575948b4bd9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bfc0a985f2efe703a5f3de5e132c93e5ddd9f99454a9a37c636d2575948b4bd9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3a08581a0a8027c036474134a0774618fdbb78a2a4c7938695b1023a74227ed1"
    sha256 cellar: :any,                 x86_64_linux:  "400e33a06541725b028e89b07f7a265d0068fa43c8cf0d31f0a13fabb356b54e"
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
