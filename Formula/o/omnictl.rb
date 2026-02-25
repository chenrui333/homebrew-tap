class Omnictl < Formula
  desc "CLI for the Sidero Omni Kubernetes management platform"
  homepage "https://omni.siderolabs.com/"
  url "https://github.com/siderolabs/omni/archive/refs/tags/v1.5.7.tar.gz"
  sha256 "50580c2e15a490813a48ca90df3000e67b55785ceace22d4d7bbfd3994abdcfe"
  # license "BSL-1.1"
  head "https://github.com/siderolabs/omni.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "09fcdbbbd92d8a7e98391807f0f9b1c935a3e172607688833a12f4bcd04f0f17"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "09fcdbbbd92d8a7e98391807f0f9b1c935a3e172607688833a12f4bcd04f0f17"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "09fcdbbbd92d8a7e98391807f0f9b1c935a3e172607688833a12f4bcd04f0f17"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b52c5dcecdb5c254573e8569a63d11ee12991977761aa5d773a20fc0be841ee1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "142f6d7e20f22d6a08eb3310dcc9511eb065ff7773c10a221341f480f541e1fe"
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
