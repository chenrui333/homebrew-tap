class Sidecar < Formula
  desc "Terminal UI for diffs, file trees, conversation history, and tasks"
  homepage "https://github.com/marcus/sidecar"
  url "https://github.com/marcus/sidecar/archive/refs/tags/v1.16.0.tar.gz"
  sha256 "ab6b418c5d3e114b014bac8c3172b60f7186e334ee41a3c4c63829cbad7c2381"
  license "MIT"
  head "https://github.com/marcus/sidecar.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a44ddfb58e09f9e347a0beaabe286e0fcc2ad3459bf7e28db639546456392241"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7c2fa9a4fcdaea0a97a900971ce135836c359cb94524c3cd8ff4ab1256af1af7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9926037b8204147364917fb63d8ed226d9197f882bee6b9996a835fb39ae3055"
    sha256 cellar: :any,                 x86_64_linux:  "9e8ca436aadee63084484c2b29c99cb59a63ecdad4443d0a73e7e722dc6d7753"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

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
