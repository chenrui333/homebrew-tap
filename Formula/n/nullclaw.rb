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
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "866887bd6e4d097fedefe858729194050e0d70570a2f1527aa8117fa663307ab"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bc57275eb83ac6a24d869c2be6da2f8002108df9dfc0eb75604801f443abcedc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "382014e53c37e56bea01c08b8cce4b95b676b5a45b07d220e93854bfda2054ef"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4ef15a3f153779d065c22559ae49b19f803d3d073a1356d84cebee9a888a1341"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b29204ec6f77f19c85f38ffff5d225bc700fe2fa21dbe8d7fe141ce04c4492cc"
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
    output = shell_output("#{bin}/nullclaw status 2>&1")
    assert_match "nullclaw Status", output
    assert_match "Provider:    openrouter", output
    assert_match "Version:     #{version}", output
    assert_match "nullclaw #{version}", shell_output("#{bin}/nullclaw version 2>&1")
  end
end
