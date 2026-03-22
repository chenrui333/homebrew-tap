class GhUnpushed < Formula
  desc "GitHub CLI extension that shows your unpushed Git commits"
  homepage "https://github.com/achoreim/gh-unpushed"
  url "https://github.com/achoreim/gh-unpushed/archive/refs/tags/v0.1.1.tar.gz"
  sha256 "adbb1ad2a7650a22e1e0bf6f7bc07a1fa6c5ec0a64bfe5436e8be843f68c3b11"
  license "MIT"
  head "https://github.com/achoreim/gh-unpushed.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, all: "bc2f77f04194c8d1cd9c1f08774a4a9bf0d59199922b7c568714f3e44c9faaa4"
  end

  depends_on "gh"

  def install
    libexec.install "gh-unpushed", "VERSION"
    bin.write_exec_script libexec/"gh-unpushed"
  end

  test do
    assert_match version.to_s, shell_output("#{bin/"gh-unpushed"} --version")

    system "git", "init", "-b", "main"
    system "git", "config", "user.name", "Homebrew"
    system "git", "config", "user.email", "brew@example.com"
    (testpath/"README.md").write("first\n")
    system "git", "add", "README.md"
    system "git", "commit", "-m", "first"

    system "git", "init", "--bare", testpath/"remote.git"
    system "git", "remote", "add", "origin", testpath/"remote.git"
    system "git", "push", "-u", "origin", "main"

    (testpath/"README.md").append_lines("second")
    system "git", "commit", "-am", "second"

    output = shell_output(bin/"gh-unpushed")
    assert_match "Unpushed commits on 'main'", output
    assert_match "second", output
  end
end
