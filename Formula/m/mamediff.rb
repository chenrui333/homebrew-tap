class Mamediff < Formula
  desc "TUI editor for managing unstaged and staged Git diffs"
  homepage "https://github.com/sile/mamediff"
  url "https://github.com/sile/mamediff/archive/refs/tags/0.1.2.tar.gz"
  sha256 "7ff3479cc559ebc754635dcf4109029f70ac0fab451ee4182d56ccc771088a72"
  license "MIT"
  head "https://github.com/sile/mamediff.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5bce2c5c5698abbbcaa5f68c512ed63c4c52476925c33fb5d54dc8aebf36ef32"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "226b071802021653bf20f68cfab6b4d504d2e3ad9cbc3ffcc96a605a2da95b16"
    sha256 cellar: :any_skip_relocation, ventura:       "6167c8f14be31d13e0bc0c414297a9289911cb2d8a18c0be02ae61e7a2a5c81c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d5008e756f2fb438e52e92a2447da3a731c57418b74f505106ecd5c6a39d6cac"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mamediff --version")

    output = shell_output("#{bin}/mamediff 2>&1", 1)
    assert_match "no `git` command found, or not a Git directory", output
  end
end
