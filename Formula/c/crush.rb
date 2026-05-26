class Crush < Formula
  desc "Glamorous AI coding agent for your favorite terminal"
  homepage "https://github.com/charmbracelet/crush"
  url "https://github.com/charmbracelet/crush/archive/refs/tags/v0.73.0.tar.gz"
  sha256 "e8c9ab048e9bf34a8936a48fd403b1838f8c1c9744d4a48da750c3bb18141185"
  # license "FSL-1.1-MIT"
  head "https://github.com/charmbracelet/crush.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9c22d87329133ee5720c99d969d018b359eb26ee6465d8f556d2e37685aaed63"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8d413e107943a241b8753b3050899b9f345fc1cf3132e62b2249ecaaa32d5ee2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cbde081ae42876d453bddb4cea8129fc5d9590cd13298f98fd6f67999009a621"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cffe16fa09c2d2b97d13387b2b151fd9efb861f091d0ca1f0413841a58f9810e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0c4b2cc9abaf8f6655bc76f12051baf5016215008b71c924120821bf516fe9ee"
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
