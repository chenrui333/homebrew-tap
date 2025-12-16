class Omnictl < Formula
  desc "CLI for the Sidero Omni Kubernetes management platform"
  homepage "https://omni.siderolabs.com/"
  url "https://github.com/siderolabs/omni/archive/refs/tags/v1.4.0.tar.gz"
  sha256 "41f4336c71cf8061f25fa67a9aebdc1da8ac162ece8cd932173b6d047b0a39a8"
  # license "BSL-1.1"
  head "https://github.com/siderolabs/omni.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "be7b4cc889aaa541f9555e6e3563d8c5666d100308cba2351e36ac3280178e89"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "be7b4cc889aaa541f9555e6e3563d8c5666d100308cba2351e36ac3280178e89"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "be7b4cc889aaa541f9555e6e3563d8c5666d100308cba2351e36ac3280178e89"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ea6b44f8973648c1fccbc702f0c1e36fc92917b82b83e73871f05fb0d7ddbbe8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d3413648a1d965861c15b60948c57644e9bac0915403efb9f8a2a25331237eef"
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
