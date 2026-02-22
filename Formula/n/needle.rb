class Needle < Formula
  desc "TUI that highlights the GitHub PRs that need you"
  homepage "https://github.com/cesarferreira/needle"
  url "https://github.com/cesarferreira/needle/archive/refs/tags/v0.14.1.tar.gz"
  sha256 "e9489a789dc45ef11783b451da215b932bd1f8d76da2287e9a5c536d09ae88a2"
  license "MIT"
  head "https://github.com/cesarferreira/needle.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "108f095af6555df8bbad494de938bd8716ad896656625b866e3e14f7a3633949"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "05d428bc8e832e19603918facf0ef69c22427f71b5042d17ad91f53724d9bd63"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "394748d75cf7d696c7c53ee5c88113dedd9673e5b0ac6b32666b158c2dbb69be"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0b4f536f5aa16e1e7200e64f76e9ca9b7cb51d709e5935480e05fcbe330aaf3e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fe4a77b820db58b3def5d82108d7de13f44b3bc10c3eaeb9606ba1212de65a46"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: ".")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/needle --version")

    output = shell_output("#{bin}/needle --demo 2>&1", 1)
    assert_match "Not a TTY", output
  end
end
