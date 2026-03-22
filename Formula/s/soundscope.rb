class Soundscope < Formula
  desc "TUI app for analyzing audio data such as frequencies and loudness (LUFS)"
  homepage "https://github.com/bananaofhappiness/soundscope"
  url "https://github.com/bananaofhappiness/soundscope/archive/refs/tags/v1.9.0.tar.gz"
  sha256 "6d4d454c52f048a334538e542fda1eb98e662e74a8b597607cc2b99194cb8890"
  license "MIT"
  head "https://github.com/bananaofhappiness/soundscope.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "eaed7335381e3967cde32b220545626154033e0b0941f65d8faab2680c096440"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "de6957a332818369dcbf3f27dd8ffde90b78701bdd51c79840e520b247eb58c8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "079473e86479322fc4ca05d171c89f8e36f3e8adb66b4577ad4dfd9ce80fed18"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0bce53f1c83ab2bd7a0a4366b7ee9b539f1f82369011cb1f208825a7ca622c84"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a98cc88da8b158eab8aa9fc18648105af1834ef047e349739a78b7e88d1ffe11"
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
