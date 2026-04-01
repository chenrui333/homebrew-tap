class Gsh < Formula
  desc "Battery-included, POSIX-compatible, generative shell"
  homepage "https://github.com/atinylittleshell/gsh"
  url "https://github.com/atinylittleshell/gsh/archive/refs/tags/v1.9.1.tar.gz"
  sha256 "f9ce76f907f818629e117282c442e6e04a82e2ed9a5405e92c8704da651a6613"
  license "GPL-3.0-only"
  head "https://github.com/atinylittleshell/gsh.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9aceea65e6d3748d5e784c8dcabe9e42612672575ef097ab2017ce816dc0a4c6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9aceea65e6d3748d5e784c8dcabe9e42612672575ef097ab2017ce816dc0a4c6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9aceea65e6d3748d5e784c8dcabe9e42612672575ef097ab2017ce816dc0a4c6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1070165415e6bedfbcc58e0debb32d0140ebeda44eed1eb5ebc76947a7e36434"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cbedfe4d6c0f4233141937a03064a15564a52908bb3cadc12a483e720272d80b"
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
