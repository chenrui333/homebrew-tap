class Omnictl < Formula
  desc "CLI for the Sidero Omni Kubernetes management platform"
  homepage "https://omni.siderolabs.com/"
  url "https://github.com/siderolabs/omni/archive/refs/tags/v0.50.0.tar.gz"
  sha256 "def0a168bdcb7dc048f56c7e7c7bfd8a4a582407d300987be930387c1424c64a"
  # license "BSL-1.1"
  head "https://github.com/siderolabs/omni.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "80d369e251833087ab8e4a02159361e8b7b565fbd4ee8979b04dcf528835f717"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d44b99771fb1fa9291beffcc406fc63a8a837575f5985af948b10cb1b919568c"
    sha256 cellar: :any_skip_relocation, ventura:       "c76d2ef96ac8df34a62d6164ce933ca56086d9d1933f19a0fde05864ece654ec"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "310be34dba5a94f5f49effb64af2081ee7335c564db22db14cd7db0f0b5882fe"
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
