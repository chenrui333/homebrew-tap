class B4n < Formula
  desc "Terminal user interface (TUI) for Kubernetes API"
  homepage "https://github.com/fioletoven/b4n"
  url "https://github.com/fioletoven/b4n/archive/refs/tags/v0.4.6.tar.gz"
  sha256 "6abce692d5c04578afc2eceddb43079a7b31618953865f6edec4083fb7b04fff"
  license "MIT"
  head "https://github.com/fioletoven/b4n.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e7bad632e374209a49a88ef3467b5b81ae08593ea83545f8d2d3f0c365b02163"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cad297f449de2a34f098cd0ab16982ab2ab5d73843762a3dad14467402094652"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b92f2be60bb7f13048ca0133d82886ce9ca400e373c541963d70ee09e2916ce9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "540fd6606c360bc00117ce9066fc124e28784678e74901f279ffc6cabc5a39db"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "098e557a7d285222821f54e0af7d1711bf184deb18b67047d374fe7b0af69b98"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/b4n --version")
    assert_match "Error: kube config file not found", shell_output("#{bin}/b4n 2>&1", 1)
  end
end
