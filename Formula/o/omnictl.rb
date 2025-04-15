class Omnictl < Formula
  desc "CLI for the Sidero Omni Kubernetes management platform"
  homepage "https://omni.siderolabs.com/"
  url "https://github.com/siderolabs/omni/archive/refs/tags/v0.48.2.tar.gz"
  sha256 "bc7631d0f1383245e07f12277b3f79ac5483c17b0b5238f8036827333cd0e25e"
  # license "BSL-1.1"
  head "https://github.com/siderolabs/omni.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f6e72fd358c3e8a232c55de61bc3584930ee95bbe248f47f2329790112781df8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "172cc4a0d8d78c06254152db3b457be19627977fbe4247b376d4357e748e96a0"
    sha256 cellar: :any_skip_relocation, ventura:       "b2338c62c747a046c9d3efd7921724084d0183261fc4deecab79fe6d56fd5cd7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e9c5e84e45dcc02d335be59f593ccd3396fc462a60723534f7f068ef2457f89a"
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
