class FastXmlParser < Formula
  desc "Validate XML, Parse XML and Build XML rapidly"
  homepage "https://naturalintelligence.github.io/fast-xml-parser/"
  url "https://registry.npmjs.org/fast-xml-parser/-/fast-xml-parser-5.2.3.tgz"
  sha256 "f156e6c4744f28ff14fd59cecfee64773f56b3d8ae344a75ad73de2bed1da1e2"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "86d9cc33359e8368a4eee09b9e584f50da8f9b7f155c36eedecd6bae4fcca070"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4a72d35dfaf1c957e38a6db49b8a0c8bce21ac24e4e821975136b23b3567104b"
    sha256 cellar: :any_skip_relocation, ventura:       "7f4af681b33014081367e101a0c044041c62fa1e7ca4e5319cef1f787fcef704"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "888a1d11db7788d44bcc2741e4f91511011c423ca97fcfa912014561f2af6dff"
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
