class Crush < Formula
  desc "Glamorous AI coding agent for your favorite terminal"
  homepage "https://github.com/charmbracelet/crush"
  url "https://github.com/charmbracelet/crush/archive/refs/tags/v0.34.0.tar.gz"
  sha256 "9ee7c64687402d783b3f592163fc93967615298ee2309291d0495ea1aeabe310"
  # license "FSL-1.1-MIT"
  head "https://github.com/charmbracelet/crush.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "478cbd29b8da1ccfb616a856ac49954a0174efc3e4c331e1de5417acc90dea17"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fb50981fcc29eca163c708c85c8921ef71788116dd59307347971e8171d5d749"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bdd57529935299e08ed48eb3446bc8d8af11fd051ea1db6a8feee918f8b49ef0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9dadadd693a875f94b88ca21cc62e3ec78614985a84a791c846fd4559ab85a92"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1fbb1a4d4307dfb49fd5056280dcafc2b6a0f59ccf8433be20269f4a0d7911d2"
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
