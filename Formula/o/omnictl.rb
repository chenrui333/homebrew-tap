class Omnictl < Formula
  desc "CLI for the Sidero Omni Kubernetes management platform"
  homepage "https://omni.siderolabs.com/"
  url "https://github.com/siderolabs/omni/archive/refs/tags/v0.46.1.tar.gz"
  sha256 "2b7d23829010a1b0c0bc4375afb896c1713f627b7ec70c17d3e0c95b4e9babb3"
  # license "BSL-1.1"
  head "https://github.com/siderolabs/omni.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b49acfe40f822077ab924efe8f015f7a2d67b7ed1bd1ec9ddaa874c00474e159"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "45adf8d3ce16f35b9adb8b2e5bbca5cc98f0af0f47416d1800fb5709cac803d7"
    sha256 cellar: :any_skip_relocation, ventura:       "a8ac8a4bb48adcc5e2df710984d994ca3864b92b61cb01e4908523148544dd6a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bd609d78df544b927f9e9b08a6a70e00458063c5f70b5a9319b2fd19c4478ba7"
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
