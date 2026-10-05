class Jjj < Formula
  desc "Modal interface for Jujutsu"
  homepage "https://jjj.isaaccorbrey.com/"
  url "https://github.com/icorbrey/jjj/archive/refs/tags/v0.2.1.tar.gz"
  sha256 "012d111279821ca9c34bdb5d2562f3241cd9cac83f1239e33fd59ded3f2daff3"
  license "MIT"
  head "https://github.com/icorbrey/jjj.git", branch: "trunk"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c8c84d0b188f85f022ae8e1e8a57abf4019bfb185e7cc8852ad424ab4e1afe49"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "490e8dfe5e8908a0edd6c6973322962fa6a067fd1129586cbdc73b8645f88c2c"
    sha256 cellar: :any,                 arm64_linux:   "40f0187341ecbd7ad9978b62ca1024228b11925d05487091a22494bb72fa4e96"
    sha256 cellar: :any,                 x86_64_linux:  "47331e20abbf602c7993609962aa7baed59a6b822aeaae469fd8eaf8877901e6"
  end

  depends_on "rust" => :build
  depends_on "jj"

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/jjj --version")

    # Fails in Linux CI with "No such device or address (os error 6)"
    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]

    begin
      output_log = testpath/"output.log"
      pid = spawn bin/"jjj", [:out, :err] => output_log.to_s
      sleep 1
      assert_match "\e[?1049h\e[?u\e[c", output_log.read
    ensure
      Process.kill("TERM", pid)
      Process.wait(pid)
    end
  end
end
