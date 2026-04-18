class Sidecar < Formula
  desc "Terminal UI for diffs, file trees, conversation history, and tasks"
  homepage "https://github.com/marcus/sidecar"
  url "https://github.com/marcus/sidecar/archive/refs/tags/v0.84.0.tar.gz"
  sha256 "43b7c821d9787297e09e61e1f5d3389d3c6f2c4000c7b7b5fb991b0cbe7db198"
  license "MIT"
  head "https://github.com/marcus/sidecar.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2a7b3e226843e75acf258c147d1cc8cf13515328ff5c464db22a1be8c62b9f39"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f55ee42bd567b18024f2d5a99c1a9657548367fb73cda3080a7564149f85275c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "78cf730bd13f8dd64b08eea08e406dbde88499a4f099d1b1e6ff154311452391"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f6a0bef86bfba2020b78e66eaef0d5fb5b11c0f8cc2c9bc312bab78a0ee2b382"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "904d2b30aee63e5c968600fb4940336a621ac588da0feb36486a13d265f8791b"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.Version=#{version}"

    system "go", "build", *std_go_args(ldflags:, output: bin/"sidecar"), "./cmd/sidecar"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/sidecar --version")
    assert_match "sidecar requires an interactive terminal",
                 shell_output("#{bin}/sidecar --project #{testpath} 2>&1", 1)
  end
end
