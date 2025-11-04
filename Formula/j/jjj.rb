class Jjj < Formula
  desc "Modal interface for Jujutsu"
  homepage "https://jjj.isaaccorbrey.com/"
  url "https://github.com/icorbrey/jjj/archive/refs/tags/v0.2.1.tar.gz"
  sha256 "012d111279821ca9c34bdb5d2562f3241cd9cac83f1239e33fd59ded3f2daff3"
  license "MIT"
  head "https://github.com/icorbrey/jjj.git", branch: "trunk"

  depends_on "rust" => :build
  depends_on "jj"

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/jjj --version")

    # Fails in Linux CI with "No such device or address (os error 6)"
    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]

    begin
      output_log = testpath/"output.log"
      pid = spawn bin/"jjj", [:out, :err] => output_log.to_s
      sleep 1
      assert_match "\e[?1049h\e[?u\e[c", output_log.read
    ensure
      Process.kill("TERM", pid)
      Process.wait(pid)
    end
  end
end
