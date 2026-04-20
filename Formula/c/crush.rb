class Crush < Formula
  desc "Glamorous AI coding agent for your favorite terminal"
  homepage "https://github.com/charmbracelet/crush"
  url "https://github.com/charmbracelet/crush/archive/refs/tags/v0.61.0.tar.gz"
  sha256 "bf1464c5f3b80befe69f42625d638f4919edb698cdc0955ce9e294bb60ce3e7c"
  # license "FSL-1.1-MIT"
  head "https://github.com/charmbracelet/crush.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "152240559c91eba7286f1a2c02aa2e8216ca0e40784512583457c92771154bd6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9660bec6d20432d3c2b4f46866c25cbc6ec012e1d9525ae99ea4c6d18c3b5bda"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e00fb144de96aa225139afd5804cda46e90699a3fc7d7fa986cbf698bb7e3d29"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8c92767e5587b343846bc88322d8ba517d2a1e1d79aff6bb4d89aee351b4e51f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "353f2183dfccec3b9196edb1eabd4b756d5ccd964940e32cfc5d1bac5163bb0f"
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
