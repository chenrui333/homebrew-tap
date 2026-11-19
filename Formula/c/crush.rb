class Crush < Formula
  desc "Glamorous AI coding agent for your favorite terminal"
  homepage "https://github.com/charmbracelet/crush"
  url "https://github.com/charmbracelet/crush/archive/refs/tags/v0.102.0.tar.gz"
  sha256 "811b96c2b67dcf9c3ccd42ceff2dfe75c135e8053a05de389ad2e2127925dcd3"
  # license "FSL-1.1-MIT"
  head "https://github.com/charmbracelet/crush.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "886b7eabf5c00df1bc44bf26a097dcd9d95f8927aa706bc968e9175b7ddb8378"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4404688ab7b66dea353558f0e85ee27f6576efa1305686f302908546b0c1246d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2ec2bff2769ea15b1cbc9fd047eca5cd7a5e0b2128938ae4a8b5974ed66a6c5d"
    sha256 cellar: :any,                 x86_64_linux:  "54762db4653ec3d6c85d2b10c88898e8a3b4b538402a17f8a3de09cdaef5871f"
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
