class Crush < Formula
  desc "Glamorous AI coding agent for your favorite terminal"
  homepage "https://github.com/charmbracelet/crush"
  url "https://github.com/charmbracelet/crush/archive/refs/tags/v0.15.0.tar.gz"
  sha256 "1299daf7c6d4e300f910f68a21277cc30451bdf4dba584ec87a57b84b2ba6933"
  # license "FSL-1.1-MIT"
  head "https://github.com/charmbracelet/crush.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5f26d18158adfcbca5011b5997cd23206a88963e904e92cddded8ffdc4202b79"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5f26d18158adfcbca5011b5997cd23206a88963e904e92cddded8ffdc4202b79"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5f26d18158adfcbca5011b5997cd23206a88963e904e92cddded8ffdc4202b79"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8014fe0528e134ef9f3436d56d866548585f9482e02d3309cbbec33b2218e9d6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e9b64100089867ab207f1bf0e862717da2188f7f74407e35710d24e95e6fc683"
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
