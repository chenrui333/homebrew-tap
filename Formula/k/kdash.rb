class Kdash < Formula
  desc "Simple and fast dashboard for Kubernetes"
  homepage "https://kdash.cli.rs/"
  url "https://github.com/kdash-rs/kdash/archive/refs/tags/v0.6.2.tar.gz"
  sha256 "1198decf3a53e53fdd4bf90a50e5d3c665ad4c4f2a483c6a3aa8a2fce6f43d8f"
  license "MIT"
  head "https://github.com/kdash-rs/kdash.git", branch: "main"

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/kdash --version")

    # failed with Linux CI, `No such device or address (os error 6)` error
    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]

    begin
      output_log = testpath/"output.log"
      pid = spawn bin/"kdash", [:out, :err] => output_log.to_s
      sleep 1
      assert_match "Unable to obtain Kubernetes client. failed to infer config", output_log.read
    ensure
      Process.kill("TERM", pid)
      Process.wait(pid)
    end
  end
end
