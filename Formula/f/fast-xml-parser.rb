class FastXmlParser < Formula
  desc "Validate XML, Parse XML and Build XML rapidly"
  homepage "https://naturalintelligence.github.io/fast-xml-parser/"
  url "https://registry.npmjs.org/fast-xml-parser/-/fast-xml-parser-5.2.5.tgz"
  sha256 "3d79a7b12748fb0ba831cbb6be1366d455ac82e90fcc558b32d05ba05c67a934"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "836fe8feff0b5dcb434923cc20d149e14779d4bcad50227151371fe289d57f8a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "42f3dc30b984bb54c1a7967c4f0de488cab9f8fbb4cde28448c9ea14bd4cd3ff"
    sha256 cellar: :any_skip_relocation, ventura:       "6e03562036e5324437265131b8b27f7d80ee14257ef3122c48b998653ae1da70"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5adab0ec0f8df644c104542a65fdbd76e592b2397c81f5b8ed9aabd5ed5dd986"
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
