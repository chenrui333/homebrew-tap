class Crush < Formula
  desc "Glamorous AI coding agent for your favorite terminal"
  homepage "https://github.com/charmbracelet/crush"
  url "https://github.com/charmbracelet/crush/archive/refs/tags/v0.20.0.tar.gz"
  sha256 "a10d74a2975b3e128bba6edd6aa6ca31985de319e5ef84f7c72adfe3acb29f4f"
  # license "FSL-1.1-MIT"
  head "https://github.com/charmbracelet/crush.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8166b93e78e770c092f1caee6c617110f9bd2d5496e005e5eb77f1af5d8131ac"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8166b93e78e770c092f1caee6c617110f9bd2d5496e005e5eb77f1af5d8131ac"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8166b93e78e770c092f1caee6c617110f9bd2d5496e005e5eb77f1af5d8131ac"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "75aabb0ba820c2189de164ba246ddaf78a60fff7348c2190a6210a3440c76217"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4943759aec9de99a2cf35e99631ccca98054a2bad797fabfb95d1240325bcce4"
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
