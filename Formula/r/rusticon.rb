class Rusticon < Formula
  desc "Mouse driven SVG favicon editor for your terminal"
  homepage "https://github.com/ronilan/rusticon"
  url "https://github.com/ronilan/rusticon/archive/refs/tags/v0.2.2.tar.gz"
  sha256 "60fb18dd973c87a123a7e41d3ba8415910333900a4f86a69c058ed6b53f76908"
  license "CC-BY-NC-ND-4.0"
  head "https://github.com/ronilan/rusticon.git", branch: "main"

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    # Fails in Linux CI with `No such device or address` error
    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]

    begin
      output_log = testpath/"output.log"
      pid = spawn bin/"rusticon", testpath, [:out, :err] => output_log.to_s
      sleep 1
      assert_match "An icon editor for the terminal", output_log.read
    ensure
      Process.kill("TERM", pid)
      Process.wait(pid)
    end
  end
end
