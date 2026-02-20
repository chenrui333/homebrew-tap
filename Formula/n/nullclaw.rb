class Nullclaw < Formula
  desc "Tiny autonomous AI assistant infrastructure written in Zig"
  homepage "https://nullclaw.github.io"
  url "https://github.com/chenrui333/nullclaw/archive/4b588ca3786e15446995ccd47b9c191ca9b3e321.tar.gz"
  version "2026.2.19"
  sha256 "64378063af232b0f07e6ea6a36f4bc05d718db6281fdcf78d26910fe16333f31"
  license "MIT"
  revision 1
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
    system "zig", "build", "-Doptimize=ReleaseFast", "-Dversion=#{version}"
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
    assert_match "Version:     #{version}", output
    assert_match "nullclaw #{version}", shell_output("#{bin}/nullclaw version 2>&1")
  end
end
