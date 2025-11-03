class FastXmlParser < Formula
  desc "Validate XML, Parse XML and Build XML rapidly"
  homepage "https://naturalintelligence.github.io/fast-xml-parser/"
  url "https://registry.npmjs.org/fast-xml-parser/-/fast-xml-parser-5.3.1.tgz"
  sha256 "c5ae97836654752c036b78fe3847260634b319b5115415b81dc521c520db01cf"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e657d74e45eeca2def9a70540275ddd6094ad836b13926c6895202ff6675c618"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "834b907502bc451a4e0ef30d78542f2c8fa6c2aa5db5d2f9ea75a7f24b183f2a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "aebddc0862912bf7f015cad0d0bfb1df2e6b8c8aa71601c1a7dc723e9159d5ed"
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
