class Crush < Formula
  desc "Glamorous AI coding agent for your favorite terminal"
  homepage "https://github.com/charmbracelet/crush"
  url "https://github.com/charmbracelet/crush/archive/refs/tags/v0.20.0.tar.gz"
  sha256 "a10d74a2975b3e128bba6edd6aa6ca31985de319e5ef84f7c72adfe3acb29f4f"
  # license "FSL-1.1-MIT"
  head "https://github.com/charmbracelet/crush.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "be0fdeaa5a9dc5d649f330e75f2af7cf659e2979e667388aae55b9ac63ea2762"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "be0fdeaa5a9dc5d649f330e75f2af7cf659e2979e667388aae55b9ac63ea2762"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "be0fdeaa5a9dc5d649f330e75f2af7cf659e2979e667388aae55b9ac63ea2762"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "96e7e68465c025865f6e6be8804d2e3286128085b08480b7d2dd124366f5f332"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "630f35872e1b81d6e3d388bd28aedaa299d4182eb47462d9bf3fc75b97227db7"
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
