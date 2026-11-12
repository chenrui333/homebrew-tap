class Crush < Formula
  desc "Glamorous AI coding agent for your favorite terminal"
  homepage "https://github.com/charmbracelet/crush"
  url "https://github.com/charmbracelet/crush/archive/refs/tags/v0.101.0.tar.gz"
  sha256 "90f6ee246b440ea537d42bdc72f495f997a9f9dbea98d15d47eb2eef9d377966"
  # license "FSL-1.1-MIT"
  head "https://github.com/charmbracelet/crush.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c689877705ee5ebe807d80470caca47b9bb735d4d13d1ee14060c57b46a6241f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6942a64be93fd5909b92aeec6e7a4f4111289131a25306e52da5c27e80846467"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f9fd4886c2ece680afc322c772f7b1879d9a219ea0c261a76cd90430ab3c6d4a"
    sha256 cellar: :any,                 x86_64_linux:  "bf7ba699506d5c8d0e34644498e03d4c63056c54e28ff0030a5a6f8b2b73a6c1"
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
