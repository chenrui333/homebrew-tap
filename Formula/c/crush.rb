class Crush < Formula
  desc "Glamorous AI coding agent for your favorite terminal"
  homepage "https://github.com/charmbracelet/crush"
  url "https://github.com/charmbracelet/crush/archive/refs/tags/v0.8.0.tar.gz"
  sha256 "123e3e7d7ca52787b679b86e212d226264cc64fde892c4f8426a371ed6b95ea3"
  # license "FSL-1.1-MIT"
  head "https://github.com/charmbracelet/crush.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fb267aa37f82b0285bb2a6e083aec12959d45df6688904b1ea3d6150693bba67"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ca44d3081a76fd921eb1c345f21cf1c1e6993a7818f6f21a4bc41ebdc6870835"
    sha256 cellar: :any_skip_relocation, ventura:       "6a9b50c07c56d9639647c43d2b1ecb15b8437afcba57d8a28a258114a691094e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "05508e589f46c2545f2feb47b88787c1ebf7a454b0b51b1be10a01b9fcd5e193"
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
