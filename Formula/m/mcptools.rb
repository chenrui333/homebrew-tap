class Mcptools < Formula
  desc "CLI for interacting with MCP servers using both stdio and HTTP transport"
  homepage "https://github.com/f/mcptools"
  url "https://github.com/f/mcptools/archive/refs/tags/v0.7.1.tar.gz"
  sha256 "048250696cd5456f9617a70d92586690973434f0ad6c9aa4481ef914fb0ef8af"
  license "MIT"
  head "https://github.com/f/mcptools.git", branch: "master"

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.Version=#{version}"), "./cmd/mcptools"

    generate_completions_from_executable(bin/"mcptools", "completion", shells: [:bash, :zsh, :fish, :pwsh])
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mcptools version")

    output = shell_output("#{bin}/mcptools configs ls")
    assert_match "No MCP servers found", output
  end
end
