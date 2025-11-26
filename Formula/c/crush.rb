class Crush < Formula
  desc "Glamorous AI coding agent for your favorite terminal"
  homepage "https://github.com/charmbracelet/crush"
  url "https://github.com/charmbracelet/crush/archive/refs/tags/v0.19.1.tar.gz"
  sha256 "8fdd7787481c0ea097239933f8c2dd7e67b1b5712210876678b8b318f12214e1"
  # license "FSL-1.1-MIT"
  head "https://github.com/charmbracelet/crush.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ae8f88790293a453481e43f22dedea29533c624414412ee1f8b639ef477ce66c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ae8f88790293a453481e43f22dedea29533c624414412ee1f8b639ef477ce66c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ae8f88790293a453481e43f22dedea29533c624414412ee1f8b639ef477ce66c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c3379d5948a5e20d2f9c3c1ce7dd81f4e06b6f26bd4144ebd96d2a2c9ca7a81e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5ebc43d480b4e3a82e7e5f63bb7968d21c3d29d2d074bf0e3b8099b29f416d7d"
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
