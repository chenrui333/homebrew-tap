class Crush < Formula
  desc "Glamorous AI coding agent for your favorite terminal"
  homepage "https://github.com/charmbracelet/crush"
  url "https://github.com/charmbracelet/crush/archive/refs/tags/v0.31.0.tar.gz"
  sha256 "442ecb58175d5cfadb8f33dc3c61796eb7160cca12654685edd418c510603a99"
  # license "FSL-1.1-MIT"
  head "https://github.com/charmbracelet/crush.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "eb1d103bbf0a1a6675415e62d5fe84441ed6be72c6d08aab98dc2b4ac7259db5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "eb1d103bbf0a1a6675415e62d5fe84441ed6be72c6d08aab98dc2b4ac7259db5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "eb1d103bbf0a1a6675415e62d5fe84441ed6be72c6d08aab98dc2b4ac7259db5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "856cf1e1ea621bd9ca7e13c48039ce9dfb15ed3317abc80d3ef4f36deb0ed491"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7a0d189e7be5b1fc47b0fc8a2755e02f2b07a9b106b357e1e7b2574f031509ff"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/charmbracelet/crush/internal/version.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"crush", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/crush --version")

    output = shell_output("#{bin}/crush run 'Explain the use of context in Go' 2>&1", 1)
    assert_match "No providers configured", output
  end
end
