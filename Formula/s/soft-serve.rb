# framework: bubbletea
class SoftServe < Formula
  desc "Mighty, self-hostable Git server for the command-line"
  homepage "https://github.com/charmbracelet/soft-serve"
  url "https://github.com/charmbracelet/soft-serve/archive/refs/tags/v0.8.2.tar.gz"
  sha256 "2a55fcc97ee3a67714b7b22f2a56be3835e65bd8bd477c311af331dacc807032"
  license "MIT"
  head "https://github.com/charmbracelet/soft-serve.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3c5e8470f089f309f0790ff844b8c9e9d163b4befa26073aa3bcc3fc639ee387"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "35ee69080c49c0a54627bc81008b58e3fb586f205d1853c8052254710c5b64b8"
    sha256 cellar: :any_skip_relocation, ventura:       "f3118af3237c82d9973d046f5e41e027c85a2aec7c987406312d229f12bc548b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cc097e6e26ae6c3cfc1cb57b43ad6ed21e18604f67bdc06187e365605fa89230"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.Version=#{version} -X main.CommitSHA=#{tap.user} -X main.CommitDate=#{time.iso8601}"
    system "go", "build", *std_go_args(ldflags:, output: bin/"soft"), "./cmd/soft"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/soft --version")

    pid = spawn bin/"soft", "serve"
    sleep 1
    Process.kill("TERM", pid)
    assert_path_exists testpath/"data/soft-serve.db"
    assert_path_exists testpath/"data/hooks/update.sample"
  end
end
