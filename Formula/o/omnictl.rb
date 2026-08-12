class Omnictl < Formula
  desc "CLI for the Sidero Omni Kubernetes management platform"
  homepage "https://omni.siderolabs.com/"
  url "https://github.com/siderolabs/omni/archive/refs/tags/v1.10.1.tar.gz"
  sha256 "22d16e2625814bcc36a8ab95139f3b518ea71bd9efb76ab5075d39319e29c98f"
  license "BUSL-1.1"
  head "https://github.com/siderolabs/omni.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "26cf59f43a71453f9fae718c0c52d62cdffc891d9721e92c88148f037e00dadf"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8036717b46a8fd094bc283117129accb2726bce7c3cca94c3881f6d87b4c4ce6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8bd1b135aabf3eb13e9ab735894c5f7d6c45ce41dec82c8dd61a8ccfbe9f59f2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "971cd083c7840cc776b932df196c9f5e76fd035945c4eb8df6ca8398d516dd38"
    sha256 cellar: :any,                 x86_64_linux:  "f4c822db909b6f5a17d07c0797d9d7e8f43d1f8cc9bbc0dbcca7d57707f2d135"
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
