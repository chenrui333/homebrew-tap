class Hcom < Formula
  desc "Let AI agents message, watch, and spawn each other across terminals"
  homepage "https://github.com/aannoo/hcom"
  url "https://github.com/aannoo/hcom/archive/refs/tags/v0.7.11.tar.gz"
  sha256 "a8cdc94ef46b392619d3ea72d4982bfd5f4a75d7cb1235f72c30ad710366a6df"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "77b1fae17f414aef54a18705031a82c1ee471d496a380412d351624a8697ff7d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a34add34cb243f7c542c0ac417bcf9c8353009e62b531097041dc952898a008d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4d02d2be17330dd916f3ca0c92657727a6b805f0dfa75ebe7bade51640de1934"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b02f0a7a031f1872bbe92657cd78694b77ac909df81ee27e1610e8c569ff4cad"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "99e0e3ff4b235c2a7b37925b73679e52bca50dfd56b719382ccb1b776d8ef43e"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/hcom --version")
  end
end
