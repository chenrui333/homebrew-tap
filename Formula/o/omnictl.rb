class Omnictl < Formula
  desc "CLI for the Sidero Omni Kubernetes management platform"
  homepage "https://omni.siderolabs.com/"
  url "https://github.com/siderolabs/omni/archive/refs/tags/v1.5.0.tar.gz"
  sha256 "f5a5fd84ad2d6da84d39a60f63bbef81bb672bb644e361ec46fa4e933b218b72"
  # license "BSL-1.1"
  head "https://github.com/siderolabs/omni.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "30c863ca9ca31575b5ed967c80193c5dcb87e67c68323a0d8d7621a7e2db0b12"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "30c863ca9ca31575b5ed967c80193c5dcb87e67c68323a0d8d7621a7e2db0b12"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "30c863ca9ca31575b5ed967c80193c5dcb87e67c68323a0d8d7621a7e2db0b12"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e538663fe58bf4c8c692d4340e7b47f057ffae822755b6fa49e5e0dac2205f3d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6d8137e7cff4bfd47b4fd3f50c0455438b6dd81e3bd05f8d4e1ebfcedb2cabbd"
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
