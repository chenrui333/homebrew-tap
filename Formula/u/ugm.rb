class Ugm < Formula
  desc "TUI to view information about UNIX users and groups"
  homepage "https://github.com/ariasmn/ugm"
  url "https://github.com/ariasmn/ugm/archive/refs/tags/v1.10.0.tar.gz"
  sha256 "d705eee28fa6f7a2f57a35e2d555c0e476f119c502f8f83e4ab39b2df8407642"
  license "MIT"
  head "https://github.com/ariasmn/ugm.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_linux:  "74d7c4a3b19da103eaa58f990be177e283166d81da89f3d5e440dbda875602d8"
    sha256 cellar: :any,                 x86_64_linux: "ef031953c6bdd1cf754c8f585c30bb31ebb5a8796c9b8d8501f126cb2dacbcdd"
  end

  depends_on "go" => :build
  depends_on :linux

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args
  end

  test do
    output = pipe_output("script -q -c '#{bin}/ugm' /dev/null", "q", 0)
    assert_match(/\d+ items/, output)
  end
end
