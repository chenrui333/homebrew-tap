class Nkv < Formula
  desc "Share your state between services using persisted key value storage"
  homepage "https://github.com/nkval/nkv"
  url "https://github.com/nkval/nkv/archive/refs/tags/0.0.6.tar.gz"
  sha256 "55d558442f7464f3b5e33d5fb6c66e94d80f56e3c76a1939db313531f5ff8d34"
  license "Apache-2.0"
  head "https://github.com/nkval/nkv.git", branch: "main"

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    # assert_match version.to_s, shell_output("#{bin}/nkv-client --version")
    system bin/"nkv-client", "--version"

    output_log = testpath/"output.log"
    pid = spawn bin/"nkv-server", "--level", "debug", [:out, :err] => output_log.to_s
    sleep 1
    assert_match "nkv_server\e[0m\e[2m:\e[0m log level is DEBUG logs will be saved to: logs", output_log.read
  ensure
    Process.kill("TERM", pid)
    Process.wait(pid)
  end
end
