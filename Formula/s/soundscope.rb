class Soundscope < Formula
  desc "TUI app for analyzing audio data such as frequencies and loudness (LUFS)"
  homepage "https://github.com/bananaofhappiness/soundscope"
  url "https://github.com/bananaofhappiness/soundscope/archive/refs/tags/v1.2.0.tar.gz"
  sha256 "156a636d08b787660336fd140870bea4137b6756bb67c1fa89883d9c92816298"
  license "MIT"
  head "https://github.com/bananaofhappiness/soundscope.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e96ed3eaf7894a41fb7e072942f2902545f6d6973372ca0e5f83a14d4e7c0c57"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4912b6935e6668e2b4c9f8d9c9723000449c3b8ccbf05ed0ad56707493952d24"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "49d21bbefe8b13b914ab063aa676082593e97f7a096f6c140cffae028868d1d9"
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
