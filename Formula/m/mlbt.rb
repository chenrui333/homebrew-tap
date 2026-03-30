class Mlbt < Formula
  desc "TUI for MLB stats API"
  homepage "https://github.com/mlb-rs/mlbt"
  url "https://github.com/mlb-rs/mlbt/archive/refs/tags/v0.2.0.tar.gz"
  sha256 "ef28455431ad0d68cbe80dbdcde06aefe362eb96e1d4f4bcc09a3eca26a0b385"
  license "MIT"
  head "https://github.com/mlb-rs/mlbt.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a88d3d22e214b27640add50290194172414ca14323c0ffebe0b3d9c29964e7e1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a5f1b6b636d8803eef48cb72b721a8c8ae9fbcb844c3e8ed3a5d94ad0039fabd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e0cdc1ce4ea823519d724549cb358340654717fe8980bf1d73ff5fc744b89041"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b3d423ce08e18c291fd3d7c4eb93b05c7c8f2968b6be83ec4bc6e2b7d5f45d57"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "94fa55f44a37c17cb9a1b171d71d250cf7dcb6e0d74a5c324f1be59ba99483c7"
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
