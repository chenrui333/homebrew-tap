class Mlbt < Formula
  desc "TUI for MLB stats API"
  homepage "https://github.com/mlb-rs/mlbt"
  url "https://github.com/mlb-rs/mlbt/archive/refs/tags/v0.6.0.tar.gz"
  sha256 "7467974f4db21004b837e589ed6cb1f89bf54c8df2813c84d3551def1e2779fa"
  license "MIT"
  head "https://github.com/mlb-rs/mlbt.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1f6c0feffa2db8a5dcf1f823014b0c23c3424b1b3b27cff76f5937b0d24a7e47"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "935f3f86f8e4a31e616d500f008385943a7b38adfd4abeb3908e6784436f6f6b"
    sha256 cellar: :any,                 arm64_linux:   "8817a784ff393302c7abbb789ab40dac714aac903fbc448b07bffa461ac27209"
    sha256 cellar: :any,                 x86_64_linux:  "ae4192b9daded0922f840de438d925fe1311d16d404612708284ce87615fa458"
  end

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

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
