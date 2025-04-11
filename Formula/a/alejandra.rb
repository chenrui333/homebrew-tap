# framework: clap
class Alejandra < Formula
  desc "Uncompromising Nix Code Formatter"
  homepage "https://kamadorueda.com/alejandra/"
  url "https://github.com/kamadorueda/alejandra/archive/refs/tags/4.0.0.tar.gz"
  sha256 "f3f9989c3fb6a56e2050bf5329692fae32a2b54be7c0652aa394afe4660ebb74"
  license "Unlicense"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "15fff49a18309d2411c1d35498a5c829a940c12556025183e6d0406785dc2884"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "92a88600ec3c0fac664fcfacdc22b9ad90a8f95219108bd725e1835915cb985c"
    sha256 cellar: :any_skip_relocation, ventura:       "9761cb345229e5c2ae0d7f45afbae33e47b130a2fc2d17a6c1dd1842cd937c2e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "db5275ae0c5b64943280e1f79ea7ca437c66ad780320ce9aac93fdeaba4aa0ff"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "src/alejandra_cli")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/alejandra --version")

    (testpath/"test.nix").write <<~EOS
      {
        foo = 123;
      }
    EOS

    output = shell_output("#{bin}/alejandra --check test.nix 2>&1")
    assert_match "Congratulations! Your code complies with the Alejandra style.", output
  end
end
