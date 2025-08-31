class Omnictl < Formula
  desc "CLI for the Sidero Omni Kubernetes management platform"
  homepage "https://omni.siderolabs.com/"
  url "https://github.com/siderolabs/omni/archive/refs/tags/v1.1.2.tar.gz"
  sha256 "676a6e9357c75880c5f94066147e035f4c57d184d5c1acf1730d2d04ee8e49ba"
  # license "BSL-1.1"
  head "https://github.com/siderolabs/omni.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "dbb28ac298f999a12bf6f5b66d8201427b6c424b148e0be536e7dc65d3522307"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e03ea0488c69d0d20f4c89deaf45c659bb672785941d78fa18a8edfd96597582"
    sha256 cellar: :any_skip_relocation, ventura:       "0e2a94840b453d3bd9ced8b5aa8ae443628eb7d6c3517bad7b6dd473ce378e2c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3e8ec3c2251085577c03631c9f91aaaa803dc7c8df14cd6e17338c5a3b99ad37"
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
