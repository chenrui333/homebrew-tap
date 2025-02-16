# framework: cobra
class Enola < Formula
  desc "Hunt down social media accounts by username across social networks"
  homepage "https://github.com/TheYahya/enola"
  url "https://github.com/TheYahya/enola/archive/refs/tags/v0.4.0.tar.gz"
  sha256 "3d1e08662a2a535773379b24d40c542fac406318c8ea6db6d6c191dfd0f2f703"
  license "MIT"
  head "https://github.com/TheYahya/enola.git", branch: "main"

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/enola"
  end

  test do
    # Fails in Linux CI with `/dev/tty: no such device or address`
    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]

    Open3.popen3("#{bin}/enola --site GitHub brewtest") do |stdin, stdout, _, wait_thr|
      stdin.close
      sleep 1
      Process.kill("TERM", wait_thr.pid)
      output = stdout.read
      assert_match "No items", output
    end
  end
end
