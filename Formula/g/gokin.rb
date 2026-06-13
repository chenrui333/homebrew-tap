class Gokin < Formula
  desc "AI-powered CLI assistant for code"
  homepage "https://gokin.ginkida.dev"
  url "https://github.com/ginkida/gokin/archive/refs/tags/v0.86.9.tar.gz"
  sha256 "42038dd8d22502ec1938ccb2a76ad9adb537b8458d052ee43dccea97fec0e552"
  license "MIT"
  head "https://github.com/ginkida/gokin.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "47e798c5fd88d62c58a6acf14846064a0dcc9ad625e6ca4420864a248f168f8a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "47e798c5fd88d62c58a6acf14846064a0dcc9ad625e6ca4420864a248f168f8a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "47e798c5fd88d62c58a6acf14846064a0dcc9ad625e6ca4420864a248f168f8a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b4d7a3c29132d89e85cceea0930f367f945f70d45dd42795b9e0acff79c2ecca"
    sha256 cellar: :any,                 x86_64_linux:  "c6fd5760f3c5050dfbf06913922c1ae219fd8fde4d1185af0ce8d209946d9ee6"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/gokin"

    generate_completions_from_executable(bin/"gokin", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gokin version")
    output = shell_output("#{bin}/gokin not-a-real-command 2>&1", 1)
    assert_match "unknown command", output
  end
end
