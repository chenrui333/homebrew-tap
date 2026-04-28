class FastXmlParser < Formula
  desc "Validate XML, Parse XML and Build XML rapidly"
  homepage "https://naturalintelligence.github.io/fast-xml-parser/"
  url "https://registry.npmjs.org/fast-xml-parser/-/fast-xml-parser-5.2.5.tgz"
  sha256 "3d79a7b12748fb0ba831cbb6be1366d455ac82e90fcc558b32d05ba05c67a934"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fb9147ba85518926ad6d874f7bf39fd87d186027036e9dfff5fbb04ef7bcf94e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8e69e1e7f73c325b9b04dc56bbbc8954a7a3fd90fb3bfe37059aad0fe48c2cf0"
    sha256 cellar: :any_skip_relocation, ventura:       "04dd228eafe953168e317265ce11ded39aaf8e0253c25aff41e7b3024dc62e65"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bfa54685d5659b6ca0e26d76dc2a0f4f268dd2c2ea4c665ce7883c39a7929702"
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
