class Mlbt < Formula
  desc "TUI for MLB stats API"
  homepage "https://github.com/mlb-rs/mlbt"
  url "https://github.com/mlb-rs/mlbt/archive/refs/tags/v0.5.0.tar.gz"
  sha256 "f173bc8e27411d50c698b5470bf8698945fb94c9fe7a6dec0686c5a95f3fd002"
  license "MIT"
  head "https://github.com/mlb-rs/mlbt.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "22fdd9ffe680a0aa873c16eca8894105017d2062ab5d14d448a765a50d62dc6a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "30597a5267bdf84aa4ec71f8626279f5594ca149355c2baf786e077931d30896"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bf81d612b5b1ac75917c41eefd490fd24fe3ab0bd5edb49884d3e806238427a0"
    sha256 cellar: :any,                 arm64_linux:   "31e15d66718fdf046129490da981d539807199974a9e4900f6927729d606975b"
    sha256 cellar: :any,                 x86_64_linux:  "1ac7a25e43783d98491a71b395d233d46b41a79a97339964028d2071c0940f85"
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
