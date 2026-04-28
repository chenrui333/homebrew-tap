class Satview < Formula
  desc "Terminal-based real-time satellite tracking and orbit prediction application"
  homepage "https://github.com/ShenMian/tracker"
  url "https://github.com/ShenMian/tracker/archive/refs/tags/v0.1.18.tar.gz"
  sha256 "6c6c82ed9fd04a8509424c3dfb932e938f47b6e30c29a128855f305804bb4496"
  license "Apache-2.0"
  head "https://github.com/ShenMian/tracker.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c8bf3b67939c21a69784de722e1aba0e043ef5570cff8c9d7d392ddf5e94051a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "69480d53790ad8519b5a3363fa662e9d29d816a1f9ccb2ab7e2d5bb8f38b7d35"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d41ede1bad7ee7a7be0295a767898791edae07310dcd4f692815918d4fb59ad7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a3c7e7bed9ac43be75646c03d72ed6aa4948675b2c1815657734be57196bd8b2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9134a7bb28bfb5b515075feeec02f160f52c98f644a88f509faaaaca528b0378"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "openssl@3"
  end

  def install
    system "cargo", "install", *std_cargo_args # artifact would still be `tracker`
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/tracker --version")

    output_log = testpath/"tracker.log"
    pid = if OS.mac?
      spawn "script", "-q", File::NULL, bin/"tracker", [:out, :err] => output_log.to_s
    else
      spawn "script", "-q", "-c", bin/"tracker", File::NULL, [:out, :err] => output_log.to_s
    end
    sleep 2
    Process.kill("TERM", pid)
    Process.wait(pid)
    output = output_log.read
    assert_match "\e[?1049h", output
    refute_match "No such device or address", output
  rescue Errno::ESRCH
    output = output_log.exist? ? output_log.read : ""
    assert_match "\e[?1049h", output
    refute_match "No such device or address", output
  end
end
