class Wishlist < Formula
  desc "SSH directory"
  homepage "https://github.com/charmbracelet/wishlist"
  url "https://github.com/charmbracelet/wishlist/archive/refs/tags/v0.15.2.tar.gz"
  sha256 "ba1a9bbd1925e2793d5eb97e38351faf5f9efdc89921af1f1322d9b88b94bdba"
  license "MIT"
  head "https://github.com/charmbracelet/wishlist.git", branch: "main"

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.Version=#{version}"), "./cmd/wishlist"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/wishlist --version")

    output_log = testpath/"output.log"
    pid = spawn bin/"wishlist", "serve", [:out, :err] => output_log.to_s
    sleep 1
    begin
      assert_match "Starting SSH server", output_log.read
      assert_path_exists testpath/".wishlist"
    ensure
      Process.kill("TERM", pid)
      Process.wait(pid)
    end
  end
end
