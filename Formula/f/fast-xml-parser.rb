class FastXmlParser < Formula
  desc "Validate XML, Parse XML and Build XML rapidly"
  homepage "https://naturalintelligence.github.io/fast-xml-parser/"
  url "https://registry.npmjs.org/fast-xml-parser/-/fast-xml-parser-5.0.9.tgz"
  sha256 "a72f9d7964479133933b2675315a75357493b7f38dfee1de61b3f7cea5f06816"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f69380e62739a738820d0ca8b4a826caef11dd13b08350bdbdaeab700bef9774"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1cf64431f0f697266bc989b1be6e612f0d4ab5ac5d2af54432279c722c06d387"
    sha256 cellar: :any_skip_relocation, ventura:       "d2f57071393fe9178d55c0680491ca47eba5107e5e9ee5bba0d1f985c4fa82af"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1b03d3a593932335d73dd7a55f46c08537c6a56e28ec79e17b28c380ae563027"
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
