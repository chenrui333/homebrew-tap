class Soundscope < Formula
  desc "TUI app for analyzing audio data such as frequencies and loudness (LUFS)"
  homepage "https://github.com/bananaofhappiness/soundscope"
  url "https://github.com/bananaofhappiness/soundscope/archive/refs/tags/v1.8.0.tar.gz"
  sha256 "62e87ada5d4fe2828dc49cf764256a6451a20700a3e98494ad5206f3b43b4e93"
  license "MIT"
  head "https://github.com/bananaofhappiness/soundscope.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d74db34a04a0c2fec69ff6cc87d1313fd2bea84a61f85e66fee415ef537cd7ef"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "38b1d7b2705a7df7d5c2b4836d7cfe2ef5fbb4efb090ed806173cc08727af5d2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "04a3874da01299af599625c8615bce561efab721ac0c8f2d2e69b56f2eaba625"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "272d7791bae285141b9bc7b6303bd34e075a9e511fcb656c4757112ae793bc27"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4a02cfa6afdc1d1b165cd8bc0e39a72625f57dc43b38b003e8c2d256a55da6d7"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "alsa-lib"
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    # Skip this part of the test on Linux because `cannot find card '0'` error
    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]

    begin
      output_log = testpath/"output.log"
      pid = spawn bin/"soundscope", testpath, [:out, :err] => output_log.to_s
      sleep 1
      assert_match "632.46Hz", output_log.read
    ensure
      Process.kill("TERM", pid)
      Process.wait(pid)
    end
  end
end
