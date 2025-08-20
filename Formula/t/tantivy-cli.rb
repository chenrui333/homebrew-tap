class TantivyCli < Formula
  desc "CLI for the Tantivy search engine"
  homepage "https://github.com/quickwit-oss/tantivy-cli"
  url "https://github.com/quickwit-oss/tantivy-cli/archive/refs/tags/0.25.0.tar.gz"
  sha256 "1f398e80d214ff53b35db3e35b7de0d6a75c9366df7c5fdce66df2e6eb0c0964"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b7a49eab533cf0cbaa0712ee283e70eb5c6556eb55df97909c25038726bc41f7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4f82c1be32dd5e0c45337410344e7440d38a920d45a05091176822470787aaf6"
    sha256 cellar: :any_skip_relocation, ventura:       "cb0da84d5f28ff74db9e2f45cea7a7c3bffa4c0a8d92e724a35876a775ccdb0f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fae7926e5d60beffcbb61e31607e9bdf22946e7fb38697cd944ac9fd9bb76bd3"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/tantivy --version")

    output = shell_output("#{bin}/tantivy index --index #{testpath} 2>&1", 1)
    assert_match "Indexing failed", output
  end
end
