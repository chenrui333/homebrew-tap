class Omnictl < Formula
  desc "CLI for the Sidero Omni Kubernetes management platform"
  homepage "https://omni.siderolabs.com/"
  url "https://github.com/siderolabs/omni/archive/refs/tags/v0.51.0.tar.gz"
  sha256 "a2d9f1deec73d1d20c170d0b59e21e1c44229dbd51715751ed814a3fb382a460"
  # license "BSL-1.1"
  head "https://github.com/siderolabs/omni.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "404010d11f2d1cb2202d79d8ea199c8a719c307d9d4656782f33a926df8e1c3c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "65e0b4ac7bdfc22836e8157bc9be558fca7933de97ee293742ec37eb40dea019"
    sha256 cellar: :any_skip_relocation, ventura:       "69aa0e83b8beebe406b0e307da10987de29a6206c92aeba8e70d54332498d023"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "41adc10be09f62eeb33bd7aa8ecf07b1c94c70d7d461d858f82ffec09f6b518a"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/omnictl"

    generate_completions_from_executable(bin/"omnictl", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/omnictl --version")

    system bin/"omnictl", "config", "new"
    assert_match "Current context: default", shell_output("#{bin}/omnictl config info")

    output = shell_output("#{bin}/omnictl cluster status test 2>&1", 1)
    assert_match "connect: connection refused", output
  end
end
