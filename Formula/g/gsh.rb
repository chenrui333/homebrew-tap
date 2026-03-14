class Gsh < Formula
  desc "Battery-included, POSIX-compatible, generative shell"
  homepage "https://github.com/atinylittleshell/gsh"
  url "https://github.com/atinylittleshell/gsh/archive/refs/tags/v1.8.0.tar.gz"
  sha256 "10a34f5c665b458f4365bf5c082a556dc5cc9dad4b7cd6a1131d40a5d4ff2aca"
  license "GPL-3.0-only"
  head "https://github.com/atinylittleshell/gsh.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5c7ce5e9e051c3291318223263434af99ac84d52edddbda063b5ac97293f7f13"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5c7ce5e9e051c3291318223263434af99ac84d52edddbda063b5ac97293f7f13"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5c7ce5e9e051c3291318223263434af99ac84d52edddbda063b5ac97293f7f13"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "347096a046a055301bc4b5a438690aa3e37cbda332236b92512b290f4e2db5e9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d8e987e95d62f6174f2f8c877de7eeeb587e9ad44c4cdc111bdc08150a8ceaf8"
  end

  depends_on "go" => :build

  def install
    tool_path = buildpath/"build_bin"
    ENV["GOBIN"] = tool_path
    ENV.prepend_path "PATH", tool_path
    system "go", "install", "golang.org/x/tools/cmd/stringer@latest"
    system "go", "generate", "./..."

    ldflags = "-s -w -X main.BUILD_VERSION=#{version}"
    system "go", "build", *std_go_args(ldflags:, output: bin/"gsh"), "./cmd/gsh/main.go"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gsh --version")
    assert_match "Telemetry:", shell_output("#{bin}/gsh telemetry status")
  end
end
