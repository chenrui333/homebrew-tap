class Omnictl < Formula
  desc "CLI for the Sidero Omni Kubernetes management platform"
  homepage "https://omni.siderolabs.com/"
  url "https://github.com/siderolabs/omni/archive/refs/tags/v0.49.1.tar.gz"
  sha256 "bbff60b1b7dbf1a66c8d170a1e1c35c901f4bde939ef34a3d4927927dcada6a8"
  # license "BSL-1.1"
  head "https://github.com/siderolabs/omni.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d1c5c4e165e8d22e7038e06b2e44a2ce7ecdffb3d43d156048af64508c81838d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "53b50334aa8a12a3fe63ac593f893d73089342893bd308c3fa642bfb75084244"
    sha256 cellar: :any_skip_relocation, ventura:       "f2067c152bce2680c120cac7974a0c9e7bbdaf2bb92b65fea6260820a45039cf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "424a86b1c3e8d79d0342482d6278fa3fa529b32f11edf9dad5955e968257501e"
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
