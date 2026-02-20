class Nullclaw < Formula
  desc "Tiny autonomous AI assistant infrastructure written in Zig"
  homepage "https://nullclaw.github.io"
  url "https://github.com/nullclaw/nullclaw/archive/refs/tags/v2026.2.19.tar.gz"
  sha256 "4d725a85c8951ce5934e3e2f7daaab287cb62073e4960b8e4c57cbf5935d4575"
  license "MIT"
  head "https://github.com/nullclaw/nullclaw.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "866887bd6e4d097fedefe858729194050e0d70570a2f1527aa8117fa663307ab"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bc57275eb83ac6a24d869c2be6da2f8002108df9dfc0eb75604801f443abcedc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "382014e53c37e56bea01c08b8cce4b95b676b5a45b07d220e93854bfda2054ef"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4ef15a3f153779d065c22559ae49b19f803d3d073a1356d84cebee9a888a1341"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b29204ec6f77f19c85f38ffff5d225bc700fe2fa21dbe8d7fe141ce04c4492cc"
  end

  depends_on "zig" => :build

  def install
    system "zig", "build", "-Doptimize=ReleaseFast"
    bin.install "zig-out/bin/nullclaw"
  end

  service do
    run [opt_bin/"nullclaw", "daemon"]
    keep_alive true
  end

  test do
    output = shell_output("#{bin}/nullclaw status 2>&1")
    assert_match "nullclaw Status", output
    assert_match "Provider:    openrouter", output
    assert_match(/\nVersion:\s+\d+\.\d+\.\d+\n/, output)

    # TODO: Re-enable when nullclaw supports `--version`:
    # https://github.com/nullclaw/nullclaw/issues/27
    # assert_match version.to_s, shell_output("#{bin}/nullclaw --version")
  end
end
