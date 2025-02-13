class Fixjson < Formula
  desc "JSON Fixer for Humans using (relaxed) JSON5"
  homepage "https://github.com/rhysd/fixjson"
  url "https://registry.npmjs.org/fixjson/-/fixjson-1.1.2.tgz"
  sha256 "28bcae94ecfbe7495f778066216946fd1858c1ff612981f4f3d6fa12a884c879"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "76d1c954139c2df7e4b4be7c06b7fc4bb362fac2b67107eb3019ddbbed05ac10"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "327d2a9117902377b6a4c9622e2ce3d668bdbc3ab0bcee7c5a32060162b390e3"
    sha256 cellar: :any_skip_relocation, ventura:       "86d19e6ba3b6bd52b7bddc9d246bc4c56c0ce9f43e5e23fd1ef4b1bbe23c660e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e06862d582f89efce9376aeedba544254ed77f4b010d45f477e2d5ccb3b7bf86"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec/"bin/fixjson"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/fixjson --version")

    (testpath/"test.json").write <<~JSON
      {
        "name": "John Doe",
        "age": 30,
        "city": "New York"
      }
    JSON

    expected_output = <<~JSON
      {
        "name": "John Doe",
        "age": 30,
        "city": "New York"
      }
    JSON

    assert_equal expected_output, shell_output("#{bin}/fixjson test.json")
  end
end
