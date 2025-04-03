class FastXmlParser < Formula
  desc "Validate XML, Parse XML and Build XML rapidly"
  homepage "https://naturalintelligence.github.io/fast-xml-parser/"
  url "https://registry.npmjs.org/fast-xml-parser/-/fast-xml-parser-5.2.0.tgz"
  sha256 "3dd6e135710c80664a1d097d8cd3620e44a595d8d2049a0d071754b3ec78bfea"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "df1654faaee990bf272ae600a63e3acea30b0e62af6db535763fdeb7ac66320c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8576fa827d34da400ad4b8947128b04c3f57d3014a9147fe62410802031fb72f"
    sha256 cellar: :any_skip_relocation, ventura:       "cc230783bd2c6a0f93c528bcd334155e080b1a85fe7e05fb4cc32132f159eebb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "67c252e96e7629222382d5ad5dfa0331b5e5e1aafd9ab0c203aaff00cb2c02ca"
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
