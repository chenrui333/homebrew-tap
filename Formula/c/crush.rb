class Crush < Formula
  desc "Glamorous AI coding agent for your favorite terminal"
  homepage "https://github.com/charmbracelet/crush"
  url "https://github.com/charmbracelet/crush/archive/refs/tags/v0.10.0.tar.gz"
  sha256 "20ae8ff28b212e38ac6a88b1885a33d36daeffdfee98c19147f2e1319819f0ff"
  # license "FSL-1.1-MIT"
  head "https://github.com/charmbracelet/crush.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "34cecdf78583b50f7fc6bbfdfb24b79a14ad9b4dc56a85bebd87310da27c4066"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e32913addb91f4aa5c78e295b39b7b9e7fd72421f4a995862ce9815f2e7a9aa4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e7bf3e77a2de633a7a5a7d485c2d20f8b070c5db61c48be0e81bde234a68dfa8"
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
    assert_match "no providers configured", output
  end
end
