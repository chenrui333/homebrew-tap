class Jiq < Formula
  desc "Interactive JSON query tool with real-time output and AI assistance"
  homepage "https://github.com/bellicose100xp/jiq"
  url "https://github.com/bellicose100xp/jiq/archive/refs/tags/v3.30.0.tar.gz"
  sha256 "319f5b23cdb505c76c01c840386a3b265eeba5e9651645b7508e435a5499d64c"
  license "Apache-2.0"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fd99c20d9e78229b6ee7edbcf6d576fa0cac003a67186197dc132a6d0062d79e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5730f68d90e490fa0e2f69194ece5072bb6af1541777b45edb8021fd81dd645e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "96c7ba26013376207552949c6410cf24cc07ce43889a3a006d1bc8560c7b5838"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3f96c62431b8a9e280f82c82ccd9ce00ddf340a96174672e609093f8b7d14a14"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d637c53b26e88c9c0af9b4c60d5b23ac59dd23cc1b77abc78f5ac5f55c90e8e3"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/jiq --version")

    (testpath/"data.json").write("{}\n")
    empty_path = testpath/"empty"
    empty_path.mkpath
    output = shell_output("PATH=#{empty_path} #{bin}/jiq #{testpath}/data.json 2>&1", 1)
    assert_match "jq binary not found in PATH.", output
  end
end
