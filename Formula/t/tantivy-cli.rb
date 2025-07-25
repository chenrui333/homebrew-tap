class TantivyCli < Formula
  desc "CLI for the Tantivy search engine"
  homepage "https://github.com/quickwit-oss/tantivy-cli"
  url "https://github.com/quickwit-oss/tantivy-cli/archive/refs/tags/0.24.tar.gz"
  sha256 "556473dcea1f54781b066bc1519701e3521b7db17110df85cfdd06689e2035c6"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "98ead2b1445d8a6aeb3c31a55ef8e8c9ad3b0d2352e9d19db5b7b200696b36df"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9d3d79cbf04ddf4a73def44d2b607233b2745d465774ddb6b9bcce1a16f74269"
    sha256 cellar: :any_skip_relocation, ventura:       "e88d45abc90bdebde472b4b2606576f0b6555e3120d9911a05200da44abe5ab1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ac57791c965a931113173d0b0472cf75db46cbdbd5874e7daa78cf46464972bd"
  end

  depends_on "rust" => :build

  # bump traitobject to 0.1.1 to build against rust 1.87, upstream pr ref, https://github.com/quickwit-oss/tantivy-cli/pull/112
  patch do
    url "https://github.com/quickwit-oss/tantivy-cli/commit/e0d4877947134ab8a9429a2a08375e0a14c5bfcf.patch?full_index=1"
    sha256 "abe9bb230580591e61e627f650914134bd2b9b2abaf4aa8775525044f7d9b2e4"
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
