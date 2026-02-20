class Omnictl < Formula
  desc "CLI for the Sidero Omni Kubernetes management platform"
  homepage "https://omni.siderolabs.com/"
  url "https://github.com/siderolabs/omni/archive/refs/tags/v1.5.5.tar.gz"
  sha256 "9b60a61edb017fd3ea248816fffa8c4438717092b221ee06da079d2a8822d1b2"
  # license "BSL-1.1"
  head "https://github.com/siderolabs/omni.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "125d38097bfad70cdbd60742d97f1300b8d0550e9bcebb3ff177c864b887e86f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "125d38097bfad70cdbd60742d97f1300b8d0550e9bcebb3ff177c864b887e86f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "125d38097bfad70cdbd60742d97f1300b8d0550e9bcebb3ff177c864b887e86f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "64e4b4d4316d76dc2665fea1ea7a2c7aa745daae2281541250e28595c1c26554"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "385ba132e2c5389a147a0a4d7b47ed322280b64742178160d1cd52087424b014"
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
