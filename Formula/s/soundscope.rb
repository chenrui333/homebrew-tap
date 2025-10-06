class Soundscope < Formula
  desc "TUI app for analyzing audio data such as frequencies and loudness (LUFS)"
  homepage "https://github.com/bananaofhappiness/soundscope"
  url "https://github.com/bananaofhappiness/soundscope/archive/refs/tags/v1.4.0.tar.gz"
  sha256 "7757f2fd4f8209f0e09f749a81a278cc157f067d31e3f31ccc0f61a8a3bb20ea"
  license "MIT"
  head "https://github.com/bananaofhappiness/soundscope.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "491455f0351a9fc636394af5d1ceb60a0f128f2964748479aac2fbf67bb2180f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "770f4c690cd82800f3178efe922fc5a1659e321c15e555fa8143a256be587d40"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "705ac6eb6b19395daef4ad8106a177f868946b0014b65eb367a476da35b7b12e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e367a62a0ac63063da13bb2a8af6e87e23347c7fd010cc7688b06cff171394fa"
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
