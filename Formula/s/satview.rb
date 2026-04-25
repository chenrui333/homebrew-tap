class Satview < Formula
  desc "Terminal-based real-time satellite tracking and orbit prediction application"
  homepage "https://github.com/ShenMian/tracker"
  url "https://github.com/ShenMian/tracker/archive/refs/tags/v0.1.20.tar.gz"
  sha256 "9a5ff9f12230b6821805a07a76e61420d52f0ed60ee4a5da2cc37917abdebebf"
  license "Apache-2.0"
  head "https://github.com/ShenMian/tracker.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "01a1e01e02a36a6aedda5b32b1c4d12427b56c2a7549a999faf304f0898e855f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9b93a6ad0338ee23fbb93a974e5797c88c77fca5e9223eec5ec4fca9d3a1c08b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "231f5dcfca0a129b330bbec2e88aff50720d794cbc8d0f522a8d9eabe2177f17"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "539ee81aa216edf62ea5a2a476158209805f4a85acc09383252c5ab900006569"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "68e976c23bf611ee6a9498c2660fb5b6ac26e3153b0180921dfa66dc17d6e046"
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
