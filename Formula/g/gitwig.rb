class Gitwig < Formula
  desc "Terminal interface for Git"
  homepage "https://github.com/tareqmy/gitwig"
  url "https://github.com/tareqmy/gitwig/archive/refs/tags/v2.6.2.tar.gz"
  sha256 "3773bfabdb82a4bea251d35e26ad716cc5b1a0549aa3b547f9a7e7ed9ca6a073"
  license "MIT"
  head "https://github.com/tareqmy/gitwig.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8e1a014324450464ad931c20279a26a0bf94bfb8bdef5b8a5b8c17fb4f370ca3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "763ce6b1f1c138d02372bcaaa258e4c4e2879e100e35a5aebaed6e544945e27a"
    sha256 cellar: :any,                 arm64_linux:   "1144d80c0e97d28b6f7828c462c85e8e0a4e08b2658395e0257ffd02f010d4d1"
    sha256 cellar: :any,                 x86_64_linux:  "e89f41ecfe174abc90af6cd335fae1cc269b6f06b42a99494fe89a0bdccb0e0f"
  end

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
