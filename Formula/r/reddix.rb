class Reddix < Formula
  desc "Reddit, refined for the terminal"
  homepage "https://github.com/ck-zhang/reddix"
  url "https://github.com/ck-zhang/reddix/archive/refs/tags/v0.2.8.tar.gz"
  sha256 "35a134cbe0a80f4df3c3931b1e9546553c37ee6caa41f48c1925e8a70946a41b"
  license "MIT"
  head "https://github.com/ck-zhang/reddix.git", branch: "master"

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/reddix --version")

    # Fails in Linux CI with "No such device or address (os error 6)"
    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]

    begin
      output_log = testpath/"output.log"
      pid = spawn bin/"reddix", testpath, [:out, :err] => output_log.to_s
      sleep 1
      assert_match "Browse Reddit galleries without leaving the terminal", output_log.read
    ensure
      Process.kill("TERM", pid)
      Process.wait(pid)
    end
  end
end
