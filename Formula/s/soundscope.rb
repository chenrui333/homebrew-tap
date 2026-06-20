class Soundscope < Formula
  desc "TUI app for analyzing audio data such as frequencies and loudness (LUFS)"
  homepage "https://github.com/bananaofhappiness/soundscope"
  url "https://github.com/bananaofhappiness/soundscope/archive/refs/tags/v1.9.2.tar.gz"
  sha256 "3e11b610a825c0088635b7da6fd78e25579a8d1ca63cf07c9bdfc5a593fefbd0"
  license "MIT"
  head "https://github.com/bananaofhappiness/soundscope.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3bc42eda3d90a0ce879f660f29cea423d2ca490870eca919ae418982e27fc127"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f2c2b5452a9a14ae18001ce104436e2b5718e54b34334b8d5fe571b5ea716ac2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a8cdf4c28bba5af0ffd68f77e30fe27f0c095747d62108f2c5caedf7298382a3"
    sha256 cellar: :any,                 arm64_linux:   "492b5dae30333ab81897d7421d7d63821ed8cdd0400e04081f6946db63b368ac"
    sha256 cellar: :any,                 x86_64_linux:  "130110e796e460b67ea3bd8e3fff45c71faafe6961593d2d037ec311b3349ec2"
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
