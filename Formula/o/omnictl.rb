class Omnictl < Formula
  desc "CLI for the Sidero Omni Kubernetes management platform"
  homepage "https://omni.siderolabs.com/"
  url "https://github.com/siderolabs/omni/archive/refs/tags/v1.4.2.tar.gz"
  sha256 "c23f98512c301c43c6c9c1f8daa54370a10b230cf2901fdcf2b014a156df24ef"
  # license "BSL-1.1"
  head "https://github.com/siderolabs/omni.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "69ca3dd138ece381ef78bb351e75249b48d00937ba2583661b5081035ebb1fb7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "69ca3dd138ece381ef78bb351e75249b48d00937ba2583661b5081035ebb1fb7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "69ca3dd138ece381ef78bb351e75249b48d00937ba2583661b5081035ebb1fb7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2172aaac46dd8cdada8dbfefebb1e5b6027437112f01382d39b400fcd4c1404d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8e6e34d383ef8662eabff3861a7720ea074e16c3021fb90f4f1db11236a1b73e"
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
