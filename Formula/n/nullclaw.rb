class Nullclaw < Formula
  desc "Tiny autonomous AI assistant infrastructure written in Zig"
  homepage "https://nullclaw.github.io"
  url "https://github.com/nullclaw/nullclaw/archive/refs/tags/v2026.2.19.tar.gz"
  sha256 "4d725a85c8951ce5934e3e2f7daaab287cb62073e4960b8e4c57cbf5935d4575"
  license "MIT"
  head "https://github.com/nullclaw/nullclaw.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "cffd2c3a5751dafb6b5cc594a31931dc5ec11a62126aa1fa2be61c8d33cadff0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5b62f9f0d646955a1e32c352ee040ae9172985a317b6f7396fbb103199678b1f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6d88a92dda891c16ff821d7eb736bd8460184bc0f148438431ab1aef59909ae7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "53babedcb18fcd1983bcfab4707b3cf7dfb43866d7fcc53167a81aef9fea9e18"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "94931f8dcb426d8c9b8ccda22238e946da23c36e7831f28d3a9374dcb1ae31d9"
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
    ENV["HOME"] = testpath

    output = shell_output("#{bin}/nullclaw status 2>&1")
    assert_match "nullclaw Status", output
    assert_match "Provider:    openrouter", output
    assert_match(/\nVersion:\s+\d+\.\d+\.\d+\n/, output)

    # TODO: Re-enable when nullclaw supports `--version`:
    # https://github.com/nullclaw/nullclaw/issues/27
    # assert_match version.to_s, shell_output("#{bin}/nullclaw --version")
  end
end
