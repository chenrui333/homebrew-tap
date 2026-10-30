class Showboat < Formula
  desc "Create executable demo documents that show and prove an agent's work"
  homepage "https://github.com/simonw/showboat"
  url "https://github.com/simonw/showboat/archive/refs/tags/v0.6.1.tar.gz"
  sha256 "4eff24c897df85e383316e3d652c03d17d688df329c4443d2bd70caba277379d"
  license "Apache-2.0"
  head "https://github.com/simonw/showboat.git", branch: "main"

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version}")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/showboat --version")

    system bin/"showboat", "init", "demo.md", "Homebrew demo"
    assert_equal "hello\n", shell_output("#{bin}/showboat exec demo.md sh 'printf \"hello\\n\"'")
    assert_match "hello", (testpath/"demo.md").read
    system bin/"showboat", "verify", "demo.md"
  end
end
