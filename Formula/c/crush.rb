class Crush < Formula
  desc "Glamorous AI coding agent for your favorite terminal"
  homepage "https://github.com/charmbracelet/crush"
  url "https://github.com/charmbracelet/crush/archive/refs/tags/v0.101.0.tar.gz"
  sha256 "90f6ee246b440ea537d42bdc72f495f997a9f9dbea98d15d47eb2eef9d377966"
  # license "FSL-1.1-MIT"
  head "https://github.com/charmbracelet/crush.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "76f502866e1da56d432708de91fa7358c43cd5089358294672e638ce7f12a03c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a8cb49e14cf252b84aaff6ffd937e062d03e28813dde75666944463b841c7911"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d05706134e185e07c83a4ccad8ea1c3d587b7cdcf9684fcaa7a4fba8384f471f"
    sha256 cellar: :any,                 x86_64_linux:  "da34855cc5d107a9b7fb24932491e7bc2e152e4a501c5f5c9f1199ad59712dbf"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = "-X github.com/charmbracelet/crush/internal/version.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"crush", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/crush --version")

    output = shell_output("#{bin}/crush run 'Explain the use of context in Go' 2>&1", 1)
    assert_match "No providers configured", output
  end
end
