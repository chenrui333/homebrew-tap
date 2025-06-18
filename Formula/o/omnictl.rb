class Omnictl < Formula
  desc "CLI for the Sidero Omni Kubernetes management platform"
  homepage "https://omni.siderolabs.com/"
  url "https://github.com/siderolabs/omni/archive/refs/tags/v0.51.0.tar.gz"
  sha256 "a2d9f1deec73d1d20c170d0b59e21e1c44229dbd51715751ed814a3fb382a460"
  # license "BSL-1.1"
  head "https://github.com/siderolabs/omni.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0d57957324e8842654d14cbfbffe08a29b7b42a868887215875d434684a94eeb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3ec556d949177feb33393a6b50f2da2c75fd6f0fdb4c56caa2150a165ac2c159"
    sha256 cellar: :any_skip_relocation, ventura:       "c717b34093f04683f2e53c782940b67c701a764c0b4f74fe01da2acff39f11a8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4cf5c9b4d82f9dbb16ee717fce6101a17b4cd6c14eb3b534320f2a292e67afb2"
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
