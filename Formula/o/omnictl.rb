class Omnictl < Formula
  desc "CLI for the Sidero Omni Kubernetes management platform"
  homepage "https://omni.siderolabs.com/"
  url "https://github.com/siderolabs/omni/archive/refs/tags/v1.14.1.tar.gz"
  sha256 "a2d436ffa0f3f2bafcfdc8a62d971aa868014030e57ab5e0f12b6e34eb83b773"
  license "BUSL-1.1"
  head "https://github.com/siderolabs/omni.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    manifest_sha256 "116e36d221db19f8e4588c3a8c5224f229576797479e451bcd889f1b038fa3c7"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "70e80eac16a125838a6534b746c3f4192e1ae4f141f8f7760b545442d94ea908"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cbd1e17b370fb12a273f164b30c81dbb5765350ead5607a3b94f570faa94b4f9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3908a530eb4724f7dc7b6c279d0b8ec786366839903ea5721f1b02d40f6e8eca"
    sha256 cellar: :any,                 x86_64_linux:  "17ce05cde94797ea11732472b7a940463f70b82f49ff7f9f3410753b420688ac"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args, "./cmd/omnictl"

    generate_completions_from_executable(bin/"omnictl", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/omnictl --version")

    system bin/"omnictl", "config", "new"
    assert_match "Current context: default", shell_output("#{bin}/omnictl config info")

    system bin/"omnictl", "config", "add", "staging", "--url", "https://omni.example.com"
    system bin/"omnictl", "config", "context", "staging"
    assert_match "Current context: staging", shell_output("#{bin}/omnictl config info")
    assert_match %r{\*\s+staging\s+https://omni\.example\.com}, shell_output("#{bin}/omnictl config contexts")
  end
end
