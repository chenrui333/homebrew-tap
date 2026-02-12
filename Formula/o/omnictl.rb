class Omnictl < Formula
  desc "CLI for the Sidero Omni Kubernetes management platform"
  homepage "https://omni.siderolabs.com/"
  url "https://github.com/siderolabs/omni/archive/refs/tags/v1.5.2.tar.gz"
  sha256 "3cbcdbe2de848d3b4a4ff1475782cd6c8d837e37d99602b2c01544e5fbdaa739"
  # license "BSL-1.1"
  head "https://github.com/siderolabs/omni.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "352fe7b01e931776797930a49a7b3313136506816799c54ad02b8b97b466dc66"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "352fe7b01e931776797930a49a7b3313136506816799c54ad02b8b97b466dc66"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "352fe7b01e931776797930a49a7b3313136506816799c54ad02b8b97b466dc66"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0c325923687704a9a3a862d8e4e0e09b26f9c6634d93247864b5c7172d359677"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f43d7b64884570a3dcfba3417cbf6c52d824e389bcd39698610f324ed190d20f"
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
