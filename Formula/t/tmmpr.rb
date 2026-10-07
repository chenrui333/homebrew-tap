class Tmmpr < Formula
  desc "Terminal mind mapper"
  homepage "https://github.com/tanciaku/tmmpr"
  url "https://github.com/tanciaku/tmmpr/archive/refs/tags/v0.1.1.tar.gz"
  sha256 "e15eb43872484147c2c9b54f618c8fb8a96d0d013e120d06e9d80a25ea0d42ec"
  license "MIT"
  head "https://github.com/tanciaku/tmmpr.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1a82d66c10219ef80d40590681f509ebe5af1b0ed7e5a62bd72510c60677028b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4d3657e7049308201e3675c81f60c7dd05e7342150241d32d40a08f376c87962"
    sha256 cellar: :any,                 arm64_linux:   "49712496200796433b9b4b60f525f3fabb9326ce8f14cdf214f9f3264448abc3"
    sha256 cellar: :any,                 x86_64_linux:  "a428adcff32185cc38b45e609657021e7313076579867f1afdb751cd0bb17ae3"
  end

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    output_log = testpath/"tmmpr.log"
    pid = if OS.mac?
      spawn "script", "-q", File::NULL, bin/"tmmpr", [:out, :err] => output_log.to_s
    else
      spawn "script", "-q", "-c", bin/"tmmpr", File::NULL, [:out, :err] => output_log.to_s
    end
    sleep 2
    Process.kill("TERM", pid) if Process.waitpid(pid, Process::WNOHANG).nil?
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
