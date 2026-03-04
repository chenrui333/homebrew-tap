class Mlbt < Formula
  desc "TUI for MLB stats API"
  homepage "https://github.com/mlb-rs/mlbt"
  url "https://github.com/mlb-rs/mlbt/archive/refs/tags/v0.1.1.tar.gz"
  sha256 "440ae10cc3284950b12fb13f6b832c3c2a7cf4587cf64d69b6d9bd04513d8a50"
  license "MIT"
  head "https://github.com/mlb-rs/mlbt.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e69eb4bc09f98d55756db129cf6c7b552186f874e5773ca56fee88fee7c00168"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "06024bfda86fefceacdb2154c98fcd36fa3383b3b3dc2b52e089347582df992f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "204cf468b1fe9d17a3eeed4ee4ba2966726f3304f6cc2f2615f05ab584fefdb3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "66c38aa04e71be435cdef96b71992c5cd2121f4f82ab71505f85df8e4445d7c4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e7b856b249d70ed2c721c3180fb6c070a585760588f6f696d4df73d460123d63"
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
