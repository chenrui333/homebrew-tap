class Soundscope < Formula
  desc "TUI app for analyzing audio data such as frequencies and loudness (LUFS)"
  homepage "https://github.com/bananaofhappiness/soundscope"
  url "https://github.com/bananaofhappiness/soundscope/archive/refs/tags/v1.1.1.tar.gz"
  sha256 "9b46af6c745aae4ca064a659b660d60a35df2d39a76ac6d8db82e971e199862f"
  license "MIT"
  head "https://github.com/bananaofhappiness/soundscope.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ee62f07d345fe20cdcbf48665501254c910c2104828e92beea9c1d179297f1c0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "84bb435089a2170f6e783d5e1e2827e9caef4dd173959e478b0c1346fd0def37"
    sha256 cellar: :any_skip_relocation, ventura:       "707206b71f01a5dac21bddb00457819aefe7369921a035f1d3ce8612a68bffc2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "223666da582965d03bafd2ec93715d1ff9fb59d361da9fef1fbe1329c804538e"
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
