class Omnictl < Formula
  desc "CLI for the Sidero Omni Kubernetes management platform"
  homepage "https://omni.siderolabs.com/"
  url "https://github.com/siderolabs/omni/archive/refs/tags/v1.7.1.tar.gz"
  sha256 "1739fdf188c623af85e01e20e61400e3848824200ded8be28fe6de7afe824494"
  # license "BSL-1.1"
  head "https://github.com/siderolabs/omni.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "43f4ca01154a604fdf825d9da6806317fac4ed80e60d92bbf3565dd2e18fddb2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c492a617d19cb93e1695953321880ef7e0b24927670e3ecc757604716c9a0474"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "30889f54cf45f6e105254aacde944c0390e247f9719c062349cb2fc3173725d6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e6b5a38c5536d9f0f127fcb11f8b4e68693043bc758efbc2624002927de92146"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "eca28d75ef11ec44b84eb0646cd427b784d8521b775011ccae3db2497aba9057"
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
