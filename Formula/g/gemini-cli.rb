class GeminiCli < Formula
  desc "CLI for Google Gemini"
  homepage "https://github.com/reugn/gemini-cli"
  url "https://github.com/reugn/gemini-cli/archive/refs/tags/v0.4.0.tar.gz"
  sha256 "5ab91899025696f63a6cf18d8f3cccd757e6bedcbe49277c2f9b0d62d27bd9a9"
  license "MIT"
  head "https://github.com/reugn/gemini-cli.git", branch: "main"

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version}"
    system "go", "build", *std_go_args(ldflags:, output: bin/"gemini"), "./cmd/gemini"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gemini --version")

    output = shell_output("#{bin}/gemini test 2>&1", 1)
    assert_match "Error: You need an auth option to use this client", output
  end
end
