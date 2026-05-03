class Mlbt < Formula
  desc "TUI for MLB stats API"
  homepage "https://github.com/mlb-rs/mlbt"
  url "https://github.com/mlb-rs/mlbt/archive/refs/tags/v0.4.0.tar.gz"
  sha256 "dee9070332edf3a3308c8db69fa7302173806931fd06a97010ad67a25181dfbf"
  license "MIT"
  head "https://github.com/mlb-rs/mlbt.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fcce4fb2a50eea0f43e06b5d2b22dfd1f8af036141b260122b14a5dae2977ecb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "dba38cc3d53ff68cd02589ae629ad87707a097c7465cda5d4991a0ef8a2b5500"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b5a7d1ba793b43223d254bcfadbbdfa5e4d83c9c884f6f5cae0fd2654550f788"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4fc77d85beec109b3ef3acf6e12bc920a80f228b6015e35070deb9af1b635e72"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "aa06394d7e911904b45d2830af34cba495280e63cdbfe49f5de697596d0cec28"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    # failed with Linux CI, `No such device or address (os error 6)`
    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]

    begin
      output_log = testpath/"output.log"
      pid = spawn bin/"mlbt", testpath, [:out, :err] => output_log.to_s
      sleep 1
      output = output_log.read
      assert_match "Gameday", output
      assert_match "Stats", output
      assert_match "Standings", output
    ensure
      Process.kill("TERM", pid)
      Process.wait(pid)
    end
  end
end
