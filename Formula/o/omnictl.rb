class Omnictl < Formula
  desc "CLI for the Sidero Omni Kubernetes management platform"
  homepage "https://omni.siderolabs.com/"
  url "https://github.com/siderolabs/omni/archive/refs/tags/v0.46.1.tar.gz"
  sha256 "2b7d23829010a1b0c0bc4375afb896c1713f627b7ec70c17d3e0c95b4e9babb3"
  # license "BSL-1.1"
  head "https://github.com/siderolabs/omni.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1a72fb4a3f60f004193c1701ce019af9b4dd1a9492ac41b22fe83d1002fc9673"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d828a98ff562da5d90d860099bc6c15e58789545dc73936b6f07719c7bbce49e"
    sha256 cellar: :any_skip_relocation, ventura:       "3ddcd6be08452be5bb2cda79565587124abcb3d3ab22b27deb67aef93e75be9c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6470424875ad5de94ce0b7a2be14409e89c70549885a6edd7ddaba7a7974683b"
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
