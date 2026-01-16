class Crush < Formula
  desc "Glamorous AI coding agent for your favorite terminal"
  homepage "https://github.com/charmbracelet/crush"
  url "https://github.com/charmbracelet/crush/archive/refs/tags/v0.33.0.tar.gz"
  sha256 "0fd9e301c61f6e597eed0dfe0cedb8abe98e763e8d26ea566ecfe31547d02451"
  # license "FSL-1.1-MIT"
  head "https://github.com/charmbracelet/crush.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0e39575e51e7d98ca4446414f2d62f77fd5d14c8538eb4b2fc0a051ef62d03ff"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0e39575e51e7d98ca4446414f2d62f77fd5d14c8538eb4b2fc0a051ef62d03ff"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0e39575e51e7d98ca4446414f2d62f77fd5d14c8538eb4b2fc0a051ef62d03ff"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b293f372e1a369f491b5dc67ff47d3dfd52f8c0b76c936593accce4082ef5440"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b774a47dea76aeef03f8ca1ca0e23bf6efe31fd005fc049176c94a33054600f7"
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
