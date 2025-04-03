class FastXmlParser < Formula
  desc "Validate XML, Parse XML and Build XML rapidly"
  homepage "https://naturalintelligence.github.io/fast-xml-parser/"
  url "https://registry.npmjs.org/fast-xml-parser/-/fast-xml-parser-5.2.0.tgz"
  sha256 "3dd6e135710c80664a1d097d8cd3620e44a595d8d2049a0d071754b3ec78bfea"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "eea24c1eda3962303fcd697083f2c58bf1411124508bc9c5fb2e024ef9f7b096"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "73bb9922f277f97359dacdae91e41b42981c1b6b3c537ed3ae09d031a860a16f"
    sha256 cellar: :any_skip_relocation, ventura:       "bc49c977bad65fc22b22cf331966cbe3efe244e589020398dfb7da1b3e5cbf44"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "273eb7b9a5cac2ece23bfe68c6f885a5c577b0faa0ec3dba3db069a86036101c"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    # create an empty package.json to avoid runtime failure
    # code refs, https://github.com/NaturalIntelligence/fast-xml-parser/blob/master/src/cli/cli.js#L13-L14
    (testpath/"package.json").write "{}"

    (testpath/"test.xml").write <<~XML
      <root>
        <child>value</child>
      </root>
    XML

    output = shell_output("#{bin}/fxparser test.xml")
    assert_equal "value", JSON.parse(output)["root"]["child"]
  end
end
