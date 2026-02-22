class Nuls < Formula
  desc "NuShell-inspired ls with colorful table output"
  homepage "https://github.com/cesarferreira/nuls"
  url "https://static.crates.io/crates/nuls/nuls-0.2.0.crate"
  sha256 "24fb69fbb3ca465f6e051d36c75867f9fbe3e358eedb931fcb65125e4946e08e"
  license "MIT"
  head "https://github.com/cesarferreira/nuls.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b3909223e336be4916f26e6e949ca0e802ad8e2f373185dd1cd733884b70bf15"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "64c99afaab8eba5265d261a428831661b547c92e1f0fa671b07954b8050ca617"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e27e8034774e098986f17940f1f4c854c011450536c346fe58f97d9504dd19fe"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "72e22625eb70403fd3e667915153a155ce70142ec0681d4f3bd226cd6eb99256"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4ef4264a94eb116efbe6d10ed0b734656956849aafd5f2d806b61d85385bae8f"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    (testpath/"foo.txt").write "hello\n"

    assert_match version.to_s, shell_output("#{bin}/nuls --version")
    assert_match "foo.txt", shell_output("#{bin}/nuls #{testpath}")
  end
end
