class Crush < Formula
  desc "Glamorous AI coding agent for your favorite terminal"
  homepage "https://github.com/charmbracelet/crush"
  url "https://github.com/charmbracelet/crush/archive/refs/tags/v0.21.0.tar.gz"
  sha256 "f98f35599dac5a9a0bf82c4fbc813340e5c3426b1d0f60a706b861ddf05226d5"
  # license "FSL-1.1-MIT"
  head "https://github.com/charmbracelet/crush.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b685ae15641f7a0ef4c3a9ba2e96762d58dcb61459838dde3d65ac3776eeca99"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b685ae15641f7a0ef4c3a9ba2e96762d58dcb61459838dde3d65ac3776eeca99"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b685ae15641f7a0ef4c3a9ba2e96762d58dcb61459838dde3d65ac3776eeca99"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "616d5ae5ffc47df67ead1452205157cd22549a57fc2a682246e1248609ed53bb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "30e5ca0c12a29c13f06148f437435ee6d80f8364ecd68e4cc8450ce47f069648"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/charmbracelet/crush/internal/version.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"crush", "completion", shells: [:bash, :zsh, :fish, :pwsh])
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/crush --version")

    output = shell_output("#{bin}/crush run 'Explain the use of context in Go' 2>&1", 1)
    assert_match "No providers configured", output
  end
end
