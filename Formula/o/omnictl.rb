class Omnictl < Formula
  desc "CLI for the Sidero Omni Kubernetes management platform"
  homepage "https://omni.siderolabs.com/"
  url "https://github.com/siderolabs/omni/archive/refs/tags/v1.1.2.tar.gz"
  sha256 "676a6e9357c75880c5f94066147e035f4c57d184d5c1acf1730d2d04ee8e49ba"
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
    # assert_match version.to_s, shell_output("#{bin}/omnictl --version")
    system bin/"omnictl", "--version"

    system bin/"omnictl", "config", "new"
    assert_match "Current context: default", shell_output("#{bin}/omnictl config info")

    output = shell_output("#{bin}/omnictl cluster status test 2>&1", 1)
    assert_match "connect: connection refused", output
  end
end
