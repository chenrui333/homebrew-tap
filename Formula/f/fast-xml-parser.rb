class FastXmlParser < Formula
  desc "Validate XML, Parse XML and Build XML rapidly"
  homepage "https://naturalintelligence.github.io/fast-xml-parser/"
  url "https://registry.npmjs.org/fast-xml-parser/-/fast-xml-parser-5.5.7.tgz"
  sha256 "e2dfab100c5bb130ec41d54508e04d7bceba1c6a9711d34ba261bda8fcd761f4"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, all: "5d104e6a90125078e1392eacc64b3aa8e906b4757ae1feb3507a800aa3ceb5ef"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
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
