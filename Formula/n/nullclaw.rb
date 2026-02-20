class Nullclaw < Formula
  desc "Tiny autonomous AI assistant infrastructure written in Zig"
  homepage "https://nullclaw.github.io"
  url "https://github.com/nullclaw/nullclaw/archive/refs/tags/v2026.2.19.tar.gz"
  sha256 "4d725a85c8951ce5934e3e2f7daaab287cb62073e4960b8e4c57cbf5935d4575"
  license "MIT"
  head "https://github.com/nullclaw/nullclaw.git", branch: "main"

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
