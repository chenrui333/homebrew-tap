class Mlbt < Formula
  desc "TUI for MLB stats API"
  homepage "https://github.com/mlb-rs/mlbt"
  url "https://github.com/mlb-rs/mlbt/archive/refs/tags/v0.0.19.tar.gz"
  sha256 "7d61181f1e622e8d801f448bdc4282ae788cb118548fdb9069cce471ca47b6dc"
  license "MIT"
  head "https://github.com/mlb-rs/mlbt.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2d2e7097a300ca16658b16b442bc4004a00ffd3c30039bc9b52224ec3f98d05a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "840161ccdeb2c270e7a26a54b2c4467da6c678b82f550e93cd618eeadbee0127"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "66cde2f02d07c190be82af879733f0c1aa21dc23fa84dddc0d67a2d1d891853d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "70785d1a80a8fd96535a445041588c0ce3bed91e4a516d4875b0fc59be551795"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7196d693497d13182e114cebc719f660d93eb6904ec806ceaae1c06c2e545145"
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
      assert_match "Gameday │ Stats │ Standings", output_log.read
    ensure
      Process.kill("TERM", pid)
      Process.wait(pid)
    end
  end
end
