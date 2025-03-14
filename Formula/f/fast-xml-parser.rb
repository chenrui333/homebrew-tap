class FastXmlParser < Formula
  desc "Validate XML, Parse XML and Build XML rapidly"
  homepage "https://naturalintelligence.github.io/fast-xml-parser/"
  url "https://registry.npmjs.org/fast-xml-parser/-/fast-xml-parser-5.0.9.tgz"
  sha256 "a72f9d7964479133933b2675315a75357493b7f38dfee1de61b3f7cea5f06816"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2b388ba954b35a9c5ca0219539c0d3e49da540c065b380ce6f6ade092db1fdab"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6ebe3c9710752fa68cd2e29f36c718ad6cb9314dce5e24815fe585b4299b7a6b"
    sha256 cellar: :any_skip_relocation, ventura:       "a257f51b78301af357430fe1526b907ee9ae11ca77555a21ed01db5dbf6063ed"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1397822c67898f0ec8eb96d144c39f039f339717e326cf93c819cbb4537a44af"
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
