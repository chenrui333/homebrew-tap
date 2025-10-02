class Omnictl < Formula
  desc "CLI for the Sidero Omni Kubernetes management platform"
  homepage "https://omni.siderolabs.com/"
  url "https://github.com/siderolabs/omni/archive/refs/tags/v1.2.1.tar.gz"
  sha256 "51df88167f04e043b077e0df0a10d02916fb6b2022ed89af80fca3502139ce73"
  # license "BSL-1.1"
  head "https://github.com/siderolabs/omni.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "040484910af93355b87e9c312e2760dd9dfcc3974b89e355589d3e869fc38ef2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e95fd5cc83a325cf9d66c411cc8f28b57e53767fe4ed49ad69032167add7c0f9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ec3d5e974641eac77d7cf6f74fcdcf0bca239cd0224fa85a238fa941e8bdacba"
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
