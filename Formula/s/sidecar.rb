class Sidecar < Formula
  desc "Terminal UI for diffs, file trees, conversation history, and tasks"
  homepage "https://github.com/marcus/sidecar"
  url "https://github.com/marcus/sidecar/archive/refs/tags/v0.94.2.tar.gz"
  sha256 "a34320ea215746f08631bfeedb93b31bc55e733c1b5f1bb03d53e3267e081455"
  license "MIT"
  head "https://github.com/marcus/sidecar.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "77034767b0c660ec6d78dda06b0bb0aebd048246542c33623e043b486e9faa41"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "35a25e39d70ba2e3fb7f5b82559d9641d950d4e9b290c31930af8f0f529f8a66"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cc32ccfe5403f2c5f49fbbd60ece2266e30a0fafd74ad42224e0d38a2901e167"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b8d0cd89ef7a62650717a23649972a913f530513e8dbb977c2bd8bb31fbb0e58"
    sha256 cellar: :any,                 x86_64_linux:  "33d804cbe5478babed0c74f0eb6fd85923bf7c47fe07e6fe520438dfb8d59cb2"
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
