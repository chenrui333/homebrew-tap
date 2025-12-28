class Omnictl < Formula
  desc "CLI for the Sidero Omni Kubernetes management platform"
  homepage "https://omni.siderolabs.com/"
  url "https://github.com/siderolabs/omni/archive/refs/tags/v1.4.6.tar.gz"
  sha256 "9508b9d81038bc3618257da23312808ea040ef0a57d7d78dc1c3e23732bde4f0"
  # license "BSL-1.1"
  head "https://github.com/siderolabs/omni.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9ce2ffc9236b274e1236be7b9d61573c1bea3db30921f52641080f74b1445127"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9ce2ffc9236b274e1236be7b9d61573c1bea3db30921f52641080f74b1445127"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9ce2ffc9236b274e1236be7b9d61573c1bea3db30921f52641080f74b1445127"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "276357c8653c1d877ccb542efbf098d24aefe55787e8785899b218aa6070a108"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7a534b243bbea02dcf90822db485da49a81df8d01eddce27280162e39ba542e4"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/omnictl"

    generate_completions_from_executable(bin/"omnictl", shell_parameter_format: :cobra)
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
