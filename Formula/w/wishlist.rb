class Wishlist < Formula
  desc "SSH directory"
  homepage "https://github.com/charmbracelet/wishlist"
  url "https://github.com/charmbracelet/wishlist/archive/refs/tags/v0.15.2.tar.gz"
  sha256 "ba1a9bbd1925e2793d5eb97e38351faf5f9efdc89921af1f1322d9b88b94bdba"
  license "MIT"
  head "https://github.com/charmbracelet/wishlist.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "19f2e828cfc443fc1eaa25198dfd5d8f5c10e0a447acc2d94183596dc44f3e89"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7fdef2477c6bd357cfc7c3cd39725406c2dae12ac5a3af1844b7290e8c062276"
    sha256 cellar: :any_skip_relocation, ventura:       "ec951814616abad4f50eea9f1bfa83018cdb34c2949a484bb65db2a53143a869"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3e97aa4142df88ea3901995c1e9d63ce7d1ade1155fe86e4b14cebb6ab591172"
  end

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
