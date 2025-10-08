class Soundscope < Formula
  desc "TUI app for analyzing audio data such as frequencies and loudness (LUFS)"
  homepage "https://github.com/bananaofhappiness/soundscope"
  url "https://github.com/bananaofhappiness/soundscope/archive/refs/tags/v1.4.0.tar.gz"
  sha256 "7757f2fd4f8209f0e09f749a81a278cc157f067d31e3f31ccc0f61a8a3bb20ea"
  license "MIT"
  head "https://github.com/bananaofhappiness/soundscope.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b22433c2235d630c956e7d9d9deb6c37cb2d48471e3c05de9f40562f210f4b4f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "142bb8a2f1a5cc529621bd73a9bd51209e49f14b53b1784421a8de0a1ac9809e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6a59e8601a8365ac0960846e6ba0cce6fb0ed87fb411b710c5e8a0a465b23f48"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "41c02dfbe8afe77513888f178b679e6a373493cd5a9a0e2d17c43b5606d4e29f"
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
