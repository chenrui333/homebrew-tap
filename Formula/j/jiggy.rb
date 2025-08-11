class Jiggy < Formula
  desc "Minimalistic cross-platform mouse jiggler written in Rust"
  homepage "https://0xdeadbeef.info/"
  url "https://github.com/0xdea/jiggy/archive/refs/tags/v1.0.0.tar.gz"
  sha256 "4aafddd91d10c8fa9ed6d385729cdde49fe717beeec5ce33da03a814b81fb07c"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2bd3cf42498bc8e7075d30288d344b5e3314b588e19cf3364b3cc2b89ff0bbea"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2b9ea9c53d12d9143b3fd879e17b4e6e9f2c35d42ab258d58a58bfc325f26417"
    sha256 cellar: :any_skip_relocation, ventura:       "141bc17a46e95a728e091d3e1eb0c4fdcb35d05033d1413c3c9fa1806fd85728"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "587dfcdd03b2b5bf0354c959028ee74f1b59238e027020669458b1737d8fcbdf"
  end

  depends_on "rust" => :build

  on_linux do
    depends_on "xdotool"
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/jiggy --version")

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
