class Crush < Formula
  desc "Glamorous AI coding agent for your favorite terminal"
  homepage "https://github.com/charmbracelet/crush"
  url "https://github.com/charmbracelet/crush/archive/refs/tags/v0.22.0.tar.gz"
  sha256 "659f54a8932457ed0bca72bf547f80aef826b5f53f9bf7192eb68f3386df6a92"
  # license "FSL-1.1-MIT"
  head "https://github.com/charmbracelet/crush.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "564cd4e3aa7dab398bf625226e98bd1de9218fdd38b5c3f2794b5e72d1d80444"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "564cd4e3aa7dab398bf625226e98bd1de9218fdd38b5c3f2794b5e72d1d80444"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "564cd4e3aa7dab398bf625226e98bd1de9218fdd38b5c3f2794b5e72d1d80444"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c0b9c574edfc3cc50a7bea0e6d7bd629f1ba54fe1d1c6a42baeb37e303350fcd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "293aa08ae3b880ef1c5c3e95b05c25f55706e025f1f86667450ca76205c8a449"
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
