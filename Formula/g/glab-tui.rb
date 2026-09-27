class GlabTui < Formula
  desc "Terminal interface for GitLab and GitHub"
  homepage "https://github.com/rcieri/glab-tui"
  url "https://github.com/rcieri/glab-tui/archive/refs/tags/v0.9.2.tar.gz"
  sha256 "da2c6d38f5d9a0b077d0483aca90be8efcd7edb0a0ce94fa6c973f1c0a5deb9e"
  license "MIT"
  head "https://github.com/rcieri/glab-tui.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "dbd8013adfd8a3245751873f932f2a2dc9f010d23c3dc08e573a28959d35b573"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "79e6d047b323ca7da83914a890f09d52c24eef798f85989ccc56dafcfd2da8cf"
    sha256 cellar: :any,                 arm64_linux:   "1ea468c55e0e590c80b689046a13d7478c75db9b648c7cfc9cc4cdb12718e884"
    sha256 cellar: :any,                 x86_64_linux:  "e141fed44e9df963d9f38c64cfe19edb07e1c3b97508fd0ccc75410835f519c2"
  end

  depends_on "rust" => :build
  depends_on "gh"
  depends_on "glab"

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/glab-tui --version")
    output = shell_output("#{bin}/glab-tui repos")
    assert_match "Recent repositories:", output
    assert_match "(none)", output
  end
end
