class GeminiCli < Formula
  desc "CLI for Google Gemini"
  homepage "https://github.com/reugn/gemini-cli"
  url "https://github.com/reugn/gemini-cli/archive/refs/tags/v0.4.0.tar.gz"
  sha256 "5ab91899025696f63a6cf18d8f3cccd757e6bedcbe49277c2f9b0d62d27bd9a9"
  license "MIT"
  head "https://github.com/reugn/gemini-cli.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "274b02c10016a612e67c06c197c7bba4a97c666ad46aca381b79eaaeee9f5ac8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ac17845ac46df5104cfad7ddac99923ccdb48d6d47dc1ac151d39e8e2cb00dfa"
    sha256 cellar: :any_skip_relocation, ventura:       "c1cc23f755d7efce92f609791b06b64c7fe8cc2ce5f85b3f619a302aa5cce3d1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "edefed31e07fe2db3dea9f2760da99a97dedfdc4b8314a126cb35139780de0dc"
  end

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
