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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0096deef50eecc87f2a3ff0c51308c946be4cdd8c9ff83ab5ab1d951e2bb1093"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7e60d6d08709a67f3584187bbe629b99e8f7bc267c8d680dace33ccd4b8862ab"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5e7681461e81abd25f82c64a80f4a3ccb2f126a5710cf15f68b2d0ccf58cb916"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "23305df57a033fc3a90d6af10f1c54c0daf737e1512649b273898a361f894e75"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3521f63d78edfe90c01b009e391227db1b4bbfc93ddfe4cfd5e027a63200971e"
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
