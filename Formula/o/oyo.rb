class Oyo < Formula
  desc "Step-through diff viewer"
  homepage "https://github.com/ahkohd/oyo"
  url "https://github.com/ahkohd/oyo/archive/refs/tags/v0.1.53.tar.gz"
  sha256 "b6210a6821851df0745696def9edcc0d7d4ac60576c65b8f5d56a928ac663049"
  license "MIT"
  head "https://github.com/ahkohd/oyo.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "363f8363f96feda93de7a5ccf87969885e67983aee3b239d850f2d1b736e7d5f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3f7c809f07621e1b9d84f7ac355a581060088fa648eb2a5ac5c6d30ced4268bf"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "410d776d44b5feb13fabdefe5f61274974673cf61bdcba7ab3e6eb29c7f08827"
    sha256 cellar: :any,                 arm64_linux:   "1152c8c40d45e5a0bd4f898f512c9023b665af19bfe876b480885c163b955766"
    sha256 cellar: :any,                 x86_64_linux:  "cd3757956c5400567521707f2736c8b8306017e17f8b46a0c8e77f567235e2f8"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "oniguruma"

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/oyo")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/oy --version")
    assert_match "github", shell_output("#{bin}/oy themes")
  end
end
