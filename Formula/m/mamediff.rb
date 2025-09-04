class Mamediff < Formula
  desc "TUI editor for managing unstaged and staged Git diffs"
  homepage "https://github.com/sile/mamediff"
  url "https://github.com/sile/mamediff/archive/refs/tags/v0.5.0.tar.gz"
  sha256 "32fa4d3f914464261143da3a61859af586348cef2476128da7a4bdbafbcdee64"
  license "MIT"
  head "https://github.com/sile/mamediff.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6b2155de77fbc581b9b4f4f51bf10d324ba52cbaf24da35cc313066ddf77e875"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f8755b150091d1684b270e2b3a41c4a680b863006835304e40baef0d32edec2b"
    sha256 cellar: :any_skip_relocation, ventura:       "0e325cac0c327a10a4bc7857dcece70474b1e6365f2fdbf91270ffb80aa55b89"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3adbeabbeaf31113a9f9ba7343cab33dc1575734efbd99863f2b671e44457693"
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
