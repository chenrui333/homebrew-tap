class Soundscope < Formula
  desc "TUI app for analyzing audio data such as frequencies and loudness (LUFS)"
  homepage "https://github.com/bananaofhappiness/soundscope"
  url "https://github.com/bananaofhappiness/soundscope/archive/refs/tags/v1.5.0.tar.gz"
  sha256 "f631f52e197f6bb43887f97bc4abe013edbf8d9816aa32c48608ac85ad4258f3"
  license "MIT"
  head "https://github.com/bananaofhappiness/soundscope.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "586cfeddfa483eb57e637d8691d52c8bb63bcb870ab45ed2c744a783feae031e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0b4df3c4b9eca72b5173aa32ca323adbe4b09a693522641fb0df7b86a4591d0b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d7ff436228f1b1e16db0dd99371b640ac6ebb81a7554249784ad4bdbad84aece"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "81934c66728f064751cbbf29dcb7f89bf5f10a3f96e425e6fdbf338726f3f20d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6dc65e163eef7c2b37e0c7dfcc9ecc4823857389d387f3030c8fa4ab3906f921"
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
