class Jiggy < Formula
  desc "Minimalistic cross-platform mouse jiggler written in Rust"
  homepage "https://0xdeadbeef.info/"
  url "https://github.com/0xdea/jiggy/archive/refs/tags/v1.0.8.tar.gz"
  sha256 "2000302173edff127cf375200749640945c2efbe7148c00270aec84e652ce26d"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2b8791483088e54fbb2066d82c90f5c0b0cdd3c6723c1e254680acfc8b08073e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "139c82c1aaf26596972cbb7e144e50df1b4cebbf04d48342e1bb3bc63bd47315"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "119615ee51800dabd6c12c365ad23a36889b13c028a729383ba8d639d931313a"
    sha256 cellar: :any,                 arm64_linux:   "774365ccc587d7ea65b5e32ae35a75fa52b3adff67d1470001e292961e91dc3f"
    sha256 cellar: :any,                 x86_64_linux:  "730c4f094b83651e48cb723d04cf26145193aa9340536f6201e203e6859ba2c6"
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
