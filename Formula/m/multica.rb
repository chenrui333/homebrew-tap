class Multica < Formula
  desc "Open-source managed agents platform for AI coding agents"
  homepage "https://github.com/multica-ai/multica"
  url "https://github.com/multica-ai/multica/archive/refs/tags/v0.3.27.tar.gz"
  sha256 "f8d903b167f44806673d0e4824a27dd36dc2447ec6db4018eb95b7972a02af3f"
  license :cannot_represent
  head "https://github.com/multica-ai/multica.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1657b6937223c00cafdcc96a2e956aa358252ea3cc9b0adb4510dc6235673b66"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1657b6937223c00cafdcc96a2e956aa358252ea3cc9b0adb4510dc6235673b66"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1657b6937223c00cafdcc96a2e956aa358252ea3cc9b0adb4510dc6235673b66"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7eac7d8400326655b8b7f1feb2a6953ee21beb052d8009562522d8bc3a1845a1"
    sha256 cellar: :any,                 x86_64_linux:  "370b5245f194f8eb6f79368f80990f06733a26b9d608fea3fb99c8287f52834e"
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
