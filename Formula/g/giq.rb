class Giq < Formula
  desc "Git CLI with AI-powered commit messages and insights"
  homepage "https://github.com/doganarif/giq"
  url "https://github.com/doganarif/giq/archive/refs/tags/v0.1.4.tar.gz"
  sha256 "d66f7b67138527c087c9a1b421d9717fa9fa91f673e6a12a02aaa571a85bdd9f"
  license "MIT"
  head "https://github.com/doganarif/giq.git", branch: "main"

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    # would print git version, like `git version 2.48.1`
    system bin/"giq", "--version"

    system "git", "init"
    system "git", "commit", "--allow-empty", "-m", "test"
    system bin/"giq", "status"
  end
end
