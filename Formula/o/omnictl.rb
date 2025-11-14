class Omnictl < Formula
  desc "CLI for the Sidero Omni Kubernetes management platform"
  homepage "https://omni.siderolabs.com/"
  url "https://github.com/siderolabs/omni/archive/refs/tags/v1.3.2.tar.gz"
  sha256 "0788890dee48aaf04d12921862e9f24db2c475cedcc87adc56148dcb2b6f0a34"
  # license "BSL-1.1"
  head "https://github.com/siderolabs/omni.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "53ae23900022120b525bec668c45d3a1e94e5004aa9aa5a01e86a23e558d07f2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "53ae23900022120b525bec668c45d3a1e94e5004aa9aa5a01e86a23e558d07f2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "53ae23900022120b525bec668c45d3a1e94e5004aa9aa5a01e86a23e558d07f2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "45335e570d1e887eb2f71121058bc151a1870d0c6ed9a595206c43de213a9495"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "881ed6b9eff87790f643128500aab100dc066b1c945cd2245b9f12fc2120513f"
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
