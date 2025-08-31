class Mamediff < Formula
  desc "TUI editor for managing unstaged and staged Git diffs"
  homepage "https://github.com/sile/mamediff"
  url "https://github.com/sile/mamediff/archive/refs/tags/v0.4.1.tar.gz"
  sha256 "fde4529baf2040a411f736805ce844c260fc3f43a50677fa9edf48bc9dea7222"
  license "MIT"
  head "https://github.com/sile/mamediff.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "aaf375a02b688d01931e0f5123a912efa0005c58cce65cc3ff653271016d6363"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "28632fd44f12d5d353cb16dde6e10a463f3b3f7891c49943ed6d4029b94a1939"
    sha256 cellar: :any_skip_relocation, ventura:       "0830a0a32a214307557a074e7a7a6e4648ed1bf06e62d5a17f9fac190d80e2df"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "739e37de1d58904ee1502d9c2eb23ecc138c056cf79d5e65761b93fefe79dd38"
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
