class Needle < Formula
  desc "TUI that highlights the GitHub PRs that need you"
  homepage "https://github.com/cesarferreira/needle"
  url "https://github.com/cesarferreira/needle/archive/refs/tags/v0.15.0.tar.gz"
  sha256 "21a0762ce4c77939b28c3ede0772e1eb980a4ab8869eb90da720fd969851c32a"
  license "MIT"
  head "https://github.com/cesarferreira/needle.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e3c98a11d202d2b798bd6ec98826186d998f5f223ac9689685d47658923fd158"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e01e28726eadc8f035c8774427891e442703732794b7d17f01ed159593be9e81"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c899778594c4c8d780fe101e62243a2c12e731b024eeabfec397c7af05f1ccb5"
    sha256 cellar: :any,                 arm64_linux:   "720d436fc08d7685342da92d2d6870563c17f303044ee511ee9f57682683d069"
    sha256 cellar: :any,                 x86_64_linux:  "e6bb79a2e49ece17f020e38df2219271056c597b391b3bdd3241c67ab95aeed9"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/needle --version")

    output = shell_output("#{bin}/needle --demo 2>&1", 1)
    assert_match "Not a TTY", output
  end
end
