class Sqlmux < Formula
  desc "Terminal database client with tmux-style panes and Vim keybindings"
  homepage "https://github.com/kackerx/sqlmux"
  url "https://github.com/kackerx/sqlmux/archive/refs/tags/v0.9.0.tar.gz"
  sha256 "74f208da4ead458842a8e49275666cebf14bf727f5fad63394e4e6b65f927a7b"
  license "MIT"
  head "https://github.com/kackerx/sqlmux.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e18215e0836d7b27d48a26d03c58feb12b490ce92be6bfab2fb901d68801b9c0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e18215e0836d7b27d48a26d03c58feb12b490ce92be6bfab2fb901d68801b9c0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "02fe115ff38e209576b87c5df7b1fe897648a32b9fd1ed1c47fcf34280f47f26"
    sha256 cellar: :any,                 x86_64_linux:  "0c5f9f5b4961db7a5064f97eac80d28558b344f187676542cdfbfe25cd05c282"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version}"), "./cmd/sqlmux"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/sqlmux --version")
    output = shell_output("#{bin}/sqlmux --where 'id = 1' 2>&1", 1)
    assert_match "--where needs --table", output
  end
end
