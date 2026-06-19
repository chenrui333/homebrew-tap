class Jiggy < Formula
  desc "Minimalistic cross-platform mouse jiggler written in Rust"
  homepage "https://0xdeadbeef.info/"
  url "https://github.com/0xdea/jiggy/archive/refs/tags/v1.0.7.tar.gz"
  sha256 "d465e89d452d7869178fd40891e40a7ebd24a8dc3d73c7f76e03565dc7b13cbe"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7a6df6a78959314f70537b6d6c16890126c994e23e3db99d11345a40aa98a05c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6aeb93d9b4e99d1672983fec011fd43d36582cbe7d95b474e9306510db9a92ec"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "75e0089682cf794051a517f5e041b5a791f3e6dde21eac567ab2a5317b8b85b0"
    sha256 cellar: :any,                 arm64_linux:   "b7c210a4990b5d00f117b69700288f14afc4e984940d6458b1f9314f39d09df0"
    sha256 cellar: :any,                 x86_64_linux:  "9dfae3a5915cde584b07990597be3c3528c8c7a1d5b20d31964291258bf9ddac"
  end

  depends_on "rust" => :build

  on_linux do
    depends_on "xdotool"
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/jiggy --version 2>&1", 1)

    # Error: DISPLAY environment variable is empty.
    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]

    begin
      output_log = testpath/"output.log"
      pid = spawn bin/"jiggy", [:out, :err] => output_log.to_s
      sleep 1
      assert_match "Just chillin' for 60s", output_log.read
    ensure
      Process.kill("TERM", pid)
      Process.wait(pid)
    end
  end
end
