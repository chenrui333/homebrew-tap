class Soundscope < Formula
  desc "TUI app for analyzing audio data such as frequencies and loudness (LUFS)"
  homepage "https://github.com/bananaofhappiness/soundscope"
  url "https://github.com/bananaofhappiness/soundscope/archive/refs/tags/v1.9.1.tar.gz"
  sha256 "2684230ade6bcaba4f76cc6d2c06d519792f4667751a214ca2dd65d5bf8c1be1"
  license "MIT"
  head "https://github.com/bananaofhappiness/soundscope.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "30bf995ba8763dfd78434d13322750c148b8adb80b0287eb0a39828b9795d087"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c00cd6e9055f9248036e5ff0110b0ed131f42772ff1354428e0f4155cda8158c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "70b7ae2b5269f0564eb2ece5957546e242d3c68fdb70409a38dc3cb63d26369e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2e09ce3feb5b4e6c6643cda27ca936e6ad7b5dcf764c744859732cb6bbafdf61"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "676d6e4b6164cc6148320a161c832a89d2fbeef33101303bb0a0261c01a20e9f"
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
