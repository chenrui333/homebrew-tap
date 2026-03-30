class Gittop < Formula
  desc "Beautiful terminal UI for visualizing Git repository statistics"
  homepage "https://github.com/hjr265/gittop"
  url "https://github.com/hjr265/gittop/archive/refs/tags/v0.4.0.tar.gz"
  sha256 "5afaf1ee423bb23b7e7cbe335bdbf2bc83da848caf2eeac82284efbe80ab3b4b"
  license "BSD-3-Clause"

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "."
  end

  test do
    system "git", "init"
    system "git", "config", "user.name", "Homebrew"
    system "git", "config", "user.email", "brew@example.com"
    (testpath/"README.md").write("hello from Homebrew\n")
    system "git", "add", "README.md"
    system "git", "commit", "-m", "init"

    command = if OS.mac?
      "printf 'q' | script -q /dev/null #{bin/"gittop"} #{testpath}"
    else
      "printf 'q' | script -qefc '#{bin/"gittop"} #{testpath}' /dev/null"
    end

    output = shell_output("#{command} 2>&1")
    assert_match "q", output
  end
end
