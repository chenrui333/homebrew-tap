class Mamediff < Formula
  desc "TUI editor for managing unstaged and staged Git diffs"
  homepage "https://github.com/sile/mamediff"
  url "https://github.com/sile/mamediff/archive/refs/tags/v0.4.0.tar.gz"
  sha256 "9fa56ecdd593506021c57e32182dfa8a92850aa766db9d5779059268ce7e819a"
  license "MIT"
  head "https://github.com/sile/mamediff.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1ff14515d2ef0fe306800d08aa0c71e03fa88d04601aca2fc0ef611763c4a999"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fc7bbb501b8aa140c7c92ac3b53b7e3f214299048a081ebd5e0d081ce58ae525"
    sha256 cellar: :any_skip_relocation, ventura:       "5a8d24246b3308c801c0162c2b90bcca78a9d7a896c42354ae727c963f7895f2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "196e58451771a2941acaddd1fe110bbb69c32865b353ffd53e6b599da6c77b06"
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
