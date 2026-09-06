class Gitwig < Formula
  desc "Terminal interface for Git"
  homepage "https://github.com/tareqmy/gitwig"
  url "https://github.com/tareqmy/gitwig/archive/refs/tags/v2.5.14.tar.gz"
  sha256 "9eb2cd1539ddcfb4d078fadb24545d8bbf759fa02a0c7b45c883a6280d3404c4"
  license "MIT"
  head "https://github.com/tareqmy/gitwig.git", branch: "master"

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "libgit2"

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gitwig --version")
    assert_match version.to_s, shell_output("#{bin}/gtg --version")
    with_env(PATH: testpath.to_s) do
      output = shell_output("#{bin}/gitwig 2>&1", 1)
      assert_match "'git' command-line tool not found on PATH", output
    end
  end
end
