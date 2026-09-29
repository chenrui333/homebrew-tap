class Gitwig < Formula
  desc "Terminal interface for Git"
  homepage "https://github.com/tareqmy/gitwig"
  url "https://github.com/tareqmy/gitwig/archive/refs/tags/v2.6.5.tar.gz"
  sha256 "ca88cbd0f691349b576a07a22b619c8db59613fc5eea3c03725abfbda878cbfa"
  license "MIT"
  head "https://github.com/tareqmy/gitwig.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "94585d59b88161712e53bcd3af7885e003b9f14aef8a0d0a21cf618f76433d6a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6328a9398dcde8f38e1009220b2b6a6b71c9bc50eb73cb178dfdc70b8f3528bf"
    sha256 cellar: :any,                 arm64_linux:   "7c2abd575b434da50399a1e7dfd36c47c230f3bee168c55f6662724ce99ea2d6"
    sha256 cellar: :any,                 x86_64_linux:  "703363bf44fc7cb62be52647b41bd622bdee5f10d8b234b4d33782bc93c8cda4"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "libgit2"

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

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
