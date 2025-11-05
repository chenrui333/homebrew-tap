class Sprofile < Formula
  desc "Blazingly fast TUI application for viewing your Spotify listening activity"
  homepage "https://github.com/GoodBoyNeon/sprofile"
  url "https://github.com/GoodBoyNeon/sprofile/archive/refs/tags/v0.2.0.tar.gz"
  sha256 "453464c1b1a7d25bf4e75ea7222e5cf2aab766469adb0afab8d8f5d999ea50c6"
  license "MIT"
  head "https://github.com/GoodBoyNeon/sprofile.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0a2af951bd5a4333b8e4f665e68536b081d9d20725894cdf67b61d5098dd018d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "52fb26bd7a27983c97f9eca0d5be919db196ce9300987be53bb5a5a084456904"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "335ca40e7d16a733a1f765ac47fe43b410939b80cfef270b0b87a23db0919401"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2d0f1de7b604cd625290c37acfe19e212752106cd5ab194668c3eee17a09e816"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d57762e867cb3893d0379e7646698fa20d331c8359c75a701dc4c8a64a9b0b37"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "openssl@3"
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    output_log = testpath/"output.log"

    pid = spawn bin/"sprofile", [:out, :err] => output_log.to_s
    sleep 1
    assert_match "* * Welcome to Sprofile! * *", output_log.read
  ensure
    Process.kill("TERM", pid)
    Process.wait(pid)
  end
end
