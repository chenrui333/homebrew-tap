class Sidecar < Formula
  desc "Terminal UI for diffs, file trees, conversation history, and tasks"
  homepage "https://github.com/marcus/sidecar"
  url "https://github.com/marcus/sidecar/archive/refs/tags/v0.98.0.tar.gz"
  sha256 "906377d05ac1212f07a6bf273a4ca673ead5a67a627a70bc5413ea9e3356ea7a"
  license "MIT"
  head "https://github.com/marcus/sidecar.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "60a33da0ab2259e5f2ac8bcdf4f0e9aa7b9be3ae615bddd373c2c497438fc56d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ce635083e21c0a29b668b37866e5c71953f52242b4ddd8b1225f21225712005f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8ff14d6a001da88c3c2f3a150d846a3229479cbfdcb7872b0b5bb11cf8e3fea0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "122feb9c03ff3ab1cc2cda01d1d3c3e8caf1c297f06174706c37b88d6e42b384"
    sha256 cellar: :any,                 x86_64_linux:  "65f5631bed041f06eee5810ce70477fd0a1fa2d87f8fc68d867d150ab13a1f50"
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
