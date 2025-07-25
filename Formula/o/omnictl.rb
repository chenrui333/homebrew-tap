class Omnictl < Formula
  desc "CLI for the Sidero Omni Kubernetes management platform"
  homepage "https://omni.siderolabs.com/"
  url "https://github.com/siderolabs/omni/archive/refs/tags/v1.0.0.tar.gz"
  sha256 "14dc12557ca7c0a77586131f2218740126938386a562e208fd64c52ef4491868"
  # license "BSL-1.1"
  head "https://github.com/siderolabs/omni.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d8f0c668500d2bd7a5a4001abc652c9bfc57476694f38e75e868cb0d8ff62a0a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d4b311474bce660c5d551e68877cc5d65628dd944c1cf6ad8b226832a52006c0"
    sha256 cellar: :any_skip_relocation, ventura:       "3d7f0dd26ca05243f754c86e7bf8c93a73cd98d5c82a4622fe2e88a65455260e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "516bc6716bb5889fc1a3ba058e83acef24368d53658b0feb23f223647bda31a1"
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
