class TantivyCli < Formula
  desc "CLI for the Tantivy search engine"
  homepage "https://github.com/quickwit-oss/tantivy-cli"
  url "https://github.com/quickwit-oss/tantivy-cli/archive/refs/tags/0.25.0.tar.gz"
  sha256 "1f398e80d214ff53b35db3e35b7de0d6a75c9366df7c5fdce66df2e6eb0c0964"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8d1ec1ff1680759264e490a569b442aa7c2c5a834ca34da6f255943bf3b6624e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1c6fa3301547f162fe9b07d8ec089deeab7e584f437c478ef58524dc6d4a9228"
    sha256 cellar: :any,                 arm64_linux:   "3ffa0875f48a8cea8d12ce0ff5fccceaf960b014bd4baaea2160728d69b775e3"
    sha256 cellar: :any,                 x86_64_linux:  "6e48c31dad2aa0a001b5b6dd7d1ef0816e4d6e686e56e54a7547a5e0ede2f1c1"
  end

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/tantivy --version")

    output = shell_output("#{bin}/tantivy index --index #{testpath} 2>&1", 1)
    assert_match "Indexing failed", output
  end
end
