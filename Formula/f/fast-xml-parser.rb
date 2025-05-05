class FastXmlParser < Formula
  desc "Validate XML, Parse XML and Build XML rapidly"
  homepage "https://naturalintelligence.github.io/fast-xml-parser/"
  url "https://registry.npmjs.org/fast-xml-parser/-/fast-xml-parser-5.2.2.tgz"
  sha256 "2b62c27346b0e79d38d6b0bedecc438760253c98ca5a00fab373d083bb415983"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "588ef854671fbc0a17365217e6cb25db82de299650f0ee87ad9d02cd43f951f1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "058a82f839b9a0eb01fbebded9076460182fd94fb5ef19c89d4589d75c23b9fe"
    sha256 cellar: :any_skip_relocation, ventura:       "754af1b7936c915bb674de154cbc8970b1efa0ca331602a9d2e6941bf892ffe4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c118a7cb8d0ebf17f2d336d2d894c468ec8172d816ee4045f619e4f0885736ff"
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
