class Multica < Formula
  desc "Open-source managed agents platform for AI coding agents"
  homepage "https://github.com/multica-ai/multica"
  url "https://github.com/multica-ai/multica/archive/refs/tags/v0.3.35.tar.gz"
  sha256 "3b05ffb158a25dfdd3bf86966d901d5e77006bafa4a0d676a5d0a0f5c048d9c5"
  license :cannot_represent
  head "https://github.com/multica-ai/multica.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "77b02b7f454c3231841910d671279807fd5e14a70706d5fb824798fa339b81ba"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "77b02b7f454c3231841910d671279807fd5e14a70706d5fb824798fa339b81ba"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "77b02b7f454c3231841910d671279807fd5e14a70706d5fb824798fa339b81ba"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e54b3e78891f7452dfa448e91ac7e3d47cb80d522ff23f56266017e85c2d8d05"
    sha256 cellar: :any,                 x86_64_linux:  "c04e9686ec80c0c2e06a5c472d5ba5617fe15d18b906f95ad6626cf6cd758213"
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
