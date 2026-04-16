class Gokin < Formula
  desc "AI-powered CLI assistant for code"
  homepage "https://gokin.ginkida.dev"
  url "https://github.com/ginkida/gokin/archive/refs/tags/v0.63.1.tar.gz"
  sha256 "304fee17343751bf4576eb550ce3f9d208b649eb4e2e8cfc30533773413acd4a"
  license "MIT"
  head "https://github.com/ginkida/gokin.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6ecf2ea2ea250527c7370222ed84b805d1d482b6c6b64176020b009ab5e2376c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6ecf2ea2ea250527c7370222ed84b805d1d482b6c6b64176020b009ab5e2376c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6ecf2ea2ea250527c7370222ed84b805d1d482b6c6b64176020b009ab5e2376c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c5a425d4c99c8a9e6981fae998d9ce7b59396d26f9bdd2a7d4e8f7563a60a2b4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "58e4e85c9944922eade1c3cb71c8b09068098c6dd98cf2397b8b02c7e842d332"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/gokin"

    generate_completions_from_executable(bin/"gokin", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gokin version")
    assert_match "Available Commands:", shell_output("#{bin}/gokin --help")
  end
end
