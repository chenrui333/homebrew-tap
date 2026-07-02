class Omnictl < Formula
  desc "CLI for the Sidero Omni Kubernetes management platform"
  homepage "https://omni.siderolabs.com/"
  url "https://github.com/siderolabs/omni/archive/refs/tags/v1.9.1.tar.gz"
  sha256 "91694fed6ca74416be35befe4f001bf3b45e973310e84ac7f8d0cdd851f565bf"
  license "BUSL-1.1"
  head "https://github.com/siderolabs/omni.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c6cba8addbffb5f479a385125b90aa1285afe0c8ed01e3cc319d9bebfccf3711"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e674bab0cab8fc4a43c3479a2e4e2456c77fa9be666011b74da0a52b0db52a79"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "dac962cda0b1e9169262c20a75caf4f465b6410cbb8050addf7d75eab4c69509"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "035114c0c521b6a935626ad5a37863675bfddad1d6192ef2d329251e218d1014"
    sha256 cellar: :any,                 x86_64_linux:  "769ccc190c6cfe088765d8071d7ced731cfe28135c218bb2276f4b8ec5b2a383"
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
