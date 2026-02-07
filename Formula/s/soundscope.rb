class Soundscope < Formula
  desc "TUI app for analyzing audio data such as frequencies and loudness (LUFS)"
  homepage "https://github.com/bananaofhappiness/soundscope"
  url "https://github.com/bananaofhappiness/soundscope/archive/refs/tags/v1.7.0.tar.gz"
  sha256 "dc38dafe1af452bb0552726d34429235154a5ebb49980717d4e12ab85bfabf4f"
  license "MIT"
  head "https://github.com/bananaofhappiness/soundscope.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ee6c9f3c920d67183f37bd47b96b7a101ef9f20c525e3a0af0ae4af6b48a15fd"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a5c40adeab681baa2f8d2b271f775e40c92fd2f3c7bea61518266440a4ce155c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "50366939e7979587fb3ec30a04ff49b032beb78cff91166895d1692eb7a500ae"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d262ed5d9f75f35639a70b6d9342e3c96b81409d2d7ec8b7512141bce983b674"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a267ba2d12ec50cfa112e8d479cc42c4290d9c6ddd1a4e410da8fe7972b5a018"
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
