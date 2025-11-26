class Crush < Formula
  desc "Glamorous AI coding agent for your favorite terminal"
  homepage "https://github.com/charmbracelet/crush"
  url "https://github.com/charmbracelet/crush/archive/refs/tags/v0.19.2.tar.gz"
  sha256 "43044e17e6fa25c7927b7b176605f554c5ce627dcc3fe8415d2bb3bf9c203c64"
  # license "FSL-1.1-MIT"
  head "https://github.com/charmbracelet/crush.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "07697c5b48db99cb27bf40d6234797d4c4993d8bbdd660af05275daa1831d634"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "07697c5b48db99cb27bf40d6234797d4c4993d8bbdd660af05275daa1831d634"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "07697c5b48db99cb27bf40d6234797d4c4993d8bbdd660af05275daa1831d634"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "261abc380d159f6dec3d2aba96fd95cae90773ffd1f6b16fc2f7cca5fa9f617e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "952e6f00d9418ed8d8c9763dd06ebfed751a4ba32e9d38c149a4f5305f72d34a"
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
