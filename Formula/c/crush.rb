class Crush < Formula
  desc "Glamorous AI coding agent for your favorite terminal"
  homepage "https://github.com/charmbracelet/crush"
  url "https://github.com/charmbracelet/crush/archive/refs/tags/v0.24.0.tar.gz"
  sha256 "deb4fc776e14ff8ab6728305ba3cac91981297567178ba8fec1a883cc0af6fbb"
  # license "FSL-1.1-MIT"
  head "https://github.com/charmbracelet/crush.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6bbd121cf36984f826b3a9e8dc0ea76afaa289256b6c664ad662adc1933a3506"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6bbd121cf36984f826b3a9e8dc0ea76afaa289256b6c664ad662adc1933a3506"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6bbd121cf36984f826b3a9e8dc0ea76afaa289256b6c664ad662adc1933a3506"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c90b06f15f277d79faf4975cc9069038431e96280a36ed90d36b6a057df6ecad"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ec6243606ab5ea923ef1bcf52124a2ce3188d67b0902f1ba62bc7a8503d37059"
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
