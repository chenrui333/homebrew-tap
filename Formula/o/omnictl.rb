class Omnictl < Formula
  desc "CLI for the Sidero Omni Kubernetes management platform"
  homepage "https://omni.siderolabs.com/"
  url "https://github.com/siderolabs/omni/archive/refs/tags/v1.1.1.tar.gz"
  sha256 "3c3d63caf31400efa5a6ae55a1b0a050fffd33a6d583bd8c653482c02b1900e8"
  # license "BSL-1.1"
  head "https://github.com/siderolabs/omni.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4b69b338065a168e57d4e279f0e6b7018f27c5239953aa3c67cf2971c94fdcbe"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8626560a297a17f9b573b81254af3b4573421883d7ac038f2dc5a93d106423e2"
    sha256 cellar: :any_skip_relocation, ventura:       "9c9e3e69988b9ed4d02027bfdde39302d053aed40e833b8e4fda8401eb8a1962"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "33453756f15ef76e90e6c636237f174a66078105b4ac37509e6d4c3444d71bd1"
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
