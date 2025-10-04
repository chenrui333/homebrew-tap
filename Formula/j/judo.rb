class Judo < Formula
  desc "Multi-database TUI for ToDo lists"
  homepage "https://github.com/giacomopiccinini/judo"
  url "https://static.crates.io/crates/judo/judo-1.1.5.crate"
  sha256 "d354f38de36d06d21a01fcc35160e62a956931c97600b76241a8ad4c731e63b4"
  license "MIT"
  head "https://github.com/giacomopiccinini/judo.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4b3f37b5c30aa4e942f2a13049e66219ad24b0a79a9b4f3b49fadbfb1c35264b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "193cd7da925bc3e06436a911a13c259b1faebcdf4853547af5988c49b1701abf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "04242488968bc5c755eaf7037729d02d846843e83a64cffd2ed0926874938861"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    # Fails in Linux CI with `No such device or address` error
    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]

    begin
      output_log = testpath/"output.log"
      pid = spawn bin/"judo", testpath, [:out, :err] => output_log.to_s
      sleep 1
      assert_match "D A T A B A S E", output_log.read
    ensure
      Process.kill("TERM", pid)
      Process.wait(pid)
    end
  end
end
