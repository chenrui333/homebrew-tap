class Mcptools < Formula
  desc "CLI for interacting with MCP servers using both stdio and HTTP transport"
  homepage "https://github.com/f/mcptools"
  url "https://github.com/f/mcptools/archive/refs/tags/v0.7.1.tar.gz"
  sha256 "048250696cd5456f9617a70d92586690973434f0ad6c9aa4481ef914fb0ef8af"
  license "MIT"
  head "https://github.com/f/mcptools.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6ec0479ac2b3c9c1266ba1c0beb4aee1784e974d46031f714fe98f42f5557ad9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "61dd379ad1a0d48b6353fd5ddcf816050dc865beae7012cd83b45c1a9fc3b185"
    sha256 cellar: :any_skip_relocation, ventura:       "d281d0b902fd9615893c76a4d22693abd1b89be95c3b1d406b512c7b10ab7f39"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f7eacb9d803d795e977b5470e5b6b7d3467563d81e6953b28ea34bc39fa8cf41"
  end

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
