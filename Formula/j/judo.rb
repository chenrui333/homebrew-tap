class Judo < Formula
  desc "Multi-database TUI for ToDo lists"
  homepage "https://github.com/giacomopiccinini/judo"
  url "https://static.crates.io/crates/judo/judo-1.1.3.crate"
  sha256 "153daec8ee35df4435b03d11b19b08a35c702438b76bc8e40448eba2ead31b94"
  license "MIT"
  head "https://github.com/giacomopiccinini/judo.git", branch: "main"

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
