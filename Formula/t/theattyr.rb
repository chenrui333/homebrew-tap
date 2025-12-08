class Theattyr < Formula
  desc "Terminal theater for playing VT100 art and animations"
  homepage "https://github.com/orhun/theattyr"
  url "https://github.com/orhun/theattyr/archive/refs/tags/v0.1.10.tar.gz"
  sha256 "c21e6051ddaa2640b864f4ece25578bc6d4c8c8d264fb17c0216a54043caa92a"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/orhun/theattyr.git", branch: "main"

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/theattyr --version")

    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]

    begin
      output_log = testpath/"output.log"
      pid = spawn bin/"theattyr", [:out, :err] => output_log.to_s
      sleep 1
      assert_match "VT100 Animations", output_log.read
    ensure
      Process.kill("TERM", pid)
      Process.wait(pid)
    end
  end
end
