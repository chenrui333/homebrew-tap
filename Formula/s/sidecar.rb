class Sidecar < Formula
  desc "Terminal UI for diffs, file trees, conversation history, and tasks"
  homepage "https://github.com/marcus/sidecar"
  url "https://github.com/marcus/sidecar/archive/refs/tags/v1.14.0.tar.gz"
  sha256 "061b202236ce3710c4218bb55bfb077b5301397f3330bdf0fdc0e55905471406"
  license "MIT"
  head "https://github.com/marcus/sidecar.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "45f89c16d3fcbff1924f3cfb0e906131e898db3714147abe9bcf70d8a6f369ec"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d0750315eb95131a5be333589f8ec7a3c3c5a7ef1d58e33ad1c6b1e63b20ff1e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8c804d8d0619fde3c42b1909a081a45b8a728c499575f127bd79ff7b0ea3e1ed"
    sha256 cellar: :any,                 x86_64_linux:  "3a3ab6a884598e181626ed615ac2156fb6fa27c0c28ae0caec34bafe161a0eb4"
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
