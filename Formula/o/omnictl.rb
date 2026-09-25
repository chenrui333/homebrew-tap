class Omnictl < Formula
  desc "CLI for the Sidero Omni Kubernetes management platform"
  homepage "https://omni.siderolabs.com/"
  url "https://github.com/siderolabs/omni/archive/refs/tags/v1.12.1.tar.gz"
  sha256 "f5d19eb8ad5e3c1274fe22270be5603438512c343776927fa4b6e933a7f9ebee"
  license "BUSL-1.1"
  head "https://github.com/siderolabs/omni.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1a1d471fb05509a000d1258f55dc0577c5de8c3504ab09d5aa08e3c050b257f2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f44cff3f66c4ac204edc8aa87479bee16196957173b53019c9e5cc454017bced"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8cf7b75477ddbdf80056c5b6a1901a0099f771755ad77ca57e792188fbfc665d"
    sha256 cellar: :any,                 x86_64_linux:  "70f77cc7e6c421b9c65afa00650778153ac26efc3ca70ba14e368c6df10cb3b9"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/omnictl"

    generate_completions_from_executable(bin/"omnictl", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/omnictl --version")

    system bin/"omnictl", "config", "new"
    assert_match "Current context: default", shell_output("#{bin}/omnictl config info")

    output = shell_output("#{bin}/omnictl cluster status test 2>&1", 1)
    assert_match "connect: connection refused", output
  end
end
