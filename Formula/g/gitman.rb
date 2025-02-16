class Gitman < Formula
  desc "TUI for creating and managing git repositories"
  homepage "https://github.com/pyrod3v/gitman"
  url "https://github.com/pyrod3v/gitman/archive/refs/tags/v1.2.0.tar.gz"
  sha256 "78aa15341cf1e8666f7e58f6d9813a8bd29e570d1e4c2eb516d88fb28ef20fb7"
  license "Apache-2.0"
  head "https://github.com/pyrod3v/gitman.git", branch: "main"

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/gitman"
  end

  test do
    output_log = testpath/"output.log"
    pid = spawn bin/"gitman", testpath, [:out, :err] => output_log.to_s
    sleep 1
    assert_match "Select Git Action", output_log.read
  ensure
    Process.kill("TERM", pid)
    Process.wait(pid)
  end
end
