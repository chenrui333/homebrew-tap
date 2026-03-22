class Soundscope < Formula
  desc "TUI app for analyzing audio data such as frequencies and loudness (LUFS)"
  homepage "https://github.com/bananaofhappiness/soundscope"
  url "https://github.com/bananaofhappiness/soundscope/archive/refs/tags/v1.9.0.tar.gz"
  sha256 "6d4d454c52f048a334538e542fda1eb98e662e74a8b597607cc2b99194cb8890"
  license "MIT"
  head "https://github.com/bananaofhappiness/soundscope.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9e3fc79f646a2958c70042a61f668b389719a6e3e64918db60f8681454b4827b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4e52503d726859b92178edf43271f2c88ced5f726c0686d0fcc3f56a959a6108"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cebb339543e4f3f435974f8a8f7ffb1cd015d81f5b710b1a4e182bd4ff8afdc9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9c65bd58844cda0da16e08a90d8d4348eaf84b0d90eca3b339d254f425f3fa7d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "241742c54aa96f22b3762a7a4328bde68c0862cdd2d896faf3dca0d116d652ec"
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
