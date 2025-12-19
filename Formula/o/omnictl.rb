class Omnictl < Formula
  desc "CLI for the Sidero Omni Kubernetes management platform"
  homepage "https://omni.siderolabs.com/"
  url "https://github.com/siderolabs/omni/archive/refs/tags/v1.4.1.tar.gz"
  sha256 "a6764b94b6c2a1fedc68ac19ccb6888d114328bffd4949bd6f8aa6fc86d9143c"
  # license "BSL-1.1"
  head "https://github.com/siderolabs/omni.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "03ccd1ce3ebf100912a47c79934bcf201af63fd8a8aac68330f8c7f0add0f9e2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "03ccd1ce3ebf100912a47c79934bcf201af63fd8a8aac68330f8c7f0add0f9e2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "03ccd1ce3ebf100912a47c79934bcf201af63fd8a8aac68330f8c7f0add0f9e2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9e30c59fffa11e95008ea7e9f3616df6dea5f07ff56041d1b264a871f213d547"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5685e08f72db746ff6e2265ede0be0405a4af75c33d48cd73eb14302a8c1bb48"
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
