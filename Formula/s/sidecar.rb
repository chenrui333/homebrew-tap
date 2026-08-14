class Sidecar < Formula
  desc "Terminal UI for diffs, file trees, conversation history, and tasks"
  homepage "https://github.com/marcus/sidecar"
  url "https://github.com/marcus/sidecar/archive/refs/tags/v0.99.0.tar.gz"
  sha256 "4b40fba415e6b9cac341573e2bada48faf85cb75f3ae771d81a8cbfc5eda7778"
  license "MIT"
  head "https://github.com/marcus/sidecar.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1efa3e2d98c71fe73509c5f8c7806b4a3cc208c675612f52f9c77a9cfc573417"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "40153dfeb9e64129111db89a44c2e5dff0abef3caf8e973cdfd4dc6eda33ece2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8b2628ede0c522a5f6d624fff8c2dd4937df46786f916e2407507960adfe4c7b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c97448459920cfb4c794be4f4a352fa963649ab8be61052b3e08a165bb14a7e5"
    sha256 cellar: :any,                 x86_64_linux:  "8c459a3e2ad01bb2e65c2a43992ab9c33c26f3140f3419803f0ed5ba133c1773"
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
