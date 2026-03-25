class Crush < Formula
  desc "Glamorous AI coding agent for your favorite terminal"
  homepage "https://github.com/charmbracelet/crush"
  url "https://github.com/charmbracelet/crush/archive/refs/tags/v0.52.0.tar.gz"
  sha256 "53462c314eb0ffb73e485f408581e4cad1b92abc1a480f3b968dafb69f464b72"
  # license "FSL-1.1-MIT"
  head "https://github.com/charmbracelet/crush.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4eeda20e08873afc10a049b5f7ac765f7246bfb7e3f9025fb62a9370ab127f89"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2cb64befa78cc75c9b2075d1f5ad9cedd11cbe842c8b8d5674e0fd8b3e0caa71"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "57c011ccbbe70326f81a11e7bf891dd3ea5126dfc7269cfb4077114a49a012f5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f8e789835f542fd576c65139ecfc05cb1ef56454326666cd389c72a670a24161"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "46ac8a56995bdb2b513fc4b11b02cda1cba823c1d82a0eecd95063ee36d73cdb"
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
