class Omnictl < Formula
  desc "CLI for the Sidero Omni Kubernetes management platform"
  homepage "https://omni.siderolabs.com/"
  url "https://github.com/siderolabs/omni/archive/refs/tags/v0.47.1.tar.gz"
  sha256 "8abcd55b5c4bc30627184ccf3688215b9c1beea00d6f71dda7bd867ee7133d65"
  # license "BSL-1.1"
  head "https://github.com/siderolabs/omni.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "40a4dcdcb2a80e971911feb2956cd8819c1440d3f9ba8a452f3ae342ec622c52"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3f4dd2792e49a99811781ab715333516ca5ecc6df82c847c8c81a354eea03152"
    sha256 cellar: :any_skip_relocation, ventura:       "29e84ee8702fe27d69602669e09f32ed9562a919278caa464b7e4e223d8ec371"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2aad22e4ee5e6743371851e2e0218238db719258c487586c3ce2b1f4cb2dd977"
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
