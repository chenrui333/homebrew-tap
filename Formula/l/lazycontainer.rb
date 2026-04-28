class Lazycontainer < Formula
  desc "Fancy terminal UI for Apple Containers"
  homepage "https://github.com/andreybleme/lazycontainer"
  url "https://github.com/andreybleme/lazycontainer/archive/refs/tags/v0.0.1.tar.gz"
  sha256 "c674297ccb1c3897865e4dd14d64ce7346f04f66430c125ad6c8bdfff0ba4228"
  license "MIT"
  head "https://github.com/andreybleme/lazycontainer.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fb7ab10c08497f6cba6233f6c1a37e9e8f270d89acd03d228271c2e4acffd2e0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6d9da41054eabbdea8565e46352153b0f1b6dd643466a3885939c818a05fe238"
    sha256 cellar: :any_skip_relocation, ventura:       "0fb686c80852a7482f5cd61faa14b0175c7eee1199b2ee32fb95f27edad3c463"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c71649720553c8ccc545d5f7a6a5889b0f1361156d0801ba39577b1779ec5ec7"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd"
  end

  test do
    require "pty"

    PTY.spawn(bin/"lazycontainer") do |r, _w, pid|
      out = r.readpartial(1024)
      assert_match "Error listing containers", out
    rescue Errno::EIO
      # GNU/Linux raises EIO when read is done on closed pty
    ensure
      Process.kill("TERM", pid)
      Process.wait(pid)
    end
  end
end
