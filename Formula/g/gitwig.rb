class Gitwig < Formula
  desc "Terminal interface for Git"
  homepage "https://github.com/tareqmy/gitwig"
  url "https://github.com/tareqmy/gitwig/archive/refs/tags/v2.6.2.tar.gz"
  sha256 "3773bfabdb82a4bea251d35e26ad716cc5b1a0549aa3b547f9a7e7ed9ca6a073"
  license "MIT"
  head "https://github.com/tareqmy/gitwig.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "96352a6748ff3406b4fc3326c227c6fe61c0c04e8d8cd36eba81f9546bfb0186"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "36099f5f94e97b0e3b14ee239801b66242d14ba3426fb788dedb82a838294303"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "63a12ed3909000d5312bd3a9d841fd7c7f6cacdbe8e95282b5f95716123011d8"
    sha256 cellar: :any,                 arm64_linux:   "48ac61d5e67a22f17a7450369270ae1d216ee2d371c8d197905986ad39db63e5"
    sha256 cellar: :any,                 x86_64_linux:  "97defb5dd0ad461259a2fa24f7dc4e7f34b6d6d6e81bee85f87530889ea46d3d"
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
