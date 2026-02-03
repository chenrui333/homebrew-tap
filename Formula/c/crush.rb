class Crush < Formula
  desc "Glamorous AI coding agent for your favorite terminal"
  homepage "https://github.com/charmbracelet/crush"
  url "https://github.com/charmbracelet/crush/archive/refs/tags/v0.39.0.tar.gz"
  sha256 "9dbe7661db14ff94dfd154a5a08ab3797f5ec94f0ab4cc71efd13c320efd7c5f"
  # license "FSL-1.1-MIT"
  head "https://github.com/charmbracelet/crush.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b986fe61385c59425b43f01cc0da6034c5cbf9eb46fd382574c1d7a472400497"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1cf89300c9e8c6edf15aee119d73f052324c39f0361283bf960d999fefbead0d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c440c4e03983c3dc0a0ddbf0cee0ad16200e2630c01afcda71205fa34f1d55b1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9924ec1f21b95127daf3c19ac06be63e0e4f77aeab62cfacd469acb125808026"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "39d733ffcfc8665204f551b35cad70eb41f25fdeccf47a60a4e3ade7a05b82e3"
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
