class Aim < Formula
  desc "Command line download/upload tool with resume"
  homepage "https://github.com/mihaigalos/aim"
  url "https://github.com/mihaigalos/aim/archive/refs/tags/1.8.6.tar.gz"
  sha256 "1f6b7bce494106e0503024eecbc75b449c9bd30a12f3286a9c44bd0dfdd2c3fb"
  license "MIT"
  head "https://github.com/mihaigalos/aim.git", branch: "main"

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/aim --version")

    output_log = testpath/"output.log"
    pid = spawn bin/"aim", "test", [:out, :err] => output_log.to_s
    sleep 2
    assert_match "Serving on:", output_log.read
  ensure
    Process.kill("TERM", pid)
    Process.wait(pid)
  end
end
