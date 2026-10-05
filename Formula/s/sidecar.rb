class Sidecar < Formula
  desc "Terminal UI for diffs, file trees, conversation history, and tasks"
  homepage "https://github.com/marcus/sidecar"
  url "https://github.com/marcus/sidecar/archive/refs/tags/v1.16.0.tar.gz"
  sha256 "ab6b418c5d3e114b014bac8c3172b60f7186e334ee41a3c4c63829cbad7c2381"
  license "MIT"
  head "https://github.com/marcus/sidecar.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8d109fe131e634c063589e4f2e609a9482eb0e580c3f028ba064f81164f57409"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "595d66036c5a99cd8f02792e7132749c0edb5c8f2dddc7bd8ec347e235673db8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "637363418aa9dfc05ab3b1299b4ffc638a90de6bff382a5028aa14cbed0d32f2"
    sha256 cellar: :any,                 x86_64_linux:  "ffbf86a1f2cc8a4e9358e14b5bd548b1aa7194b4894a453175a29918ae466657"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.Version=#{version}"

    system "go", "build", *std_go_args(ldflags:, output: bin/"sidecar"), "./cmd/sidecar"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/sidecar --version")
    assert_match "Sidecar requires an interactive terminal",
                 shell_output("#{bin}/sidecar --project #{testpath} 2>&1", 1)
  end
end
