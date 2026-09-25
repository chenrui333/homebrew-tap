class Mlbt < Formula
  desc "TUI for MLB stats API"
  homepage "https://github.com/mlb-rs/mlbt"
  url "https://github.com/mlb-rs/mlbt/archive/refs/tags/v0.6.0.tar.gz"
  sha256 "7467974f4db21004b837e589ed6cb1f89bf54c8df2813c84d3551def1e2779fa"
  license "MIT"
  head "https://github.com/mlb-rs/mlbt.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6a1b5e48fb56eddd611501cbf81d894993f6b9245a96296bd5eee2eb750084e0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9efab4e50b5910c16c6c09a787beaa379e48b2b9d72c5722ff3f56cb17211fad"
    sha256 cellar: :any,                 arm64_linux:   "ce40d18e125a7cd7d35d4118b2978bdac5adaac6c47bc4f9fbe501ea8750a2e0"
    sha256 cellar: :any,                 x86_64_linux:  "9b51364cb4d48f65516d0f76cd4823c45c3567eb02c1d06094953b018f7ec38e"
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
