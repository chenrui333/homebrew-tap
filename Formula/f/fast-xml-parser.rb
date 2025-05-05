class FastXmlParser < Formula
  desc "Validate XML, Parse XML and Build XML rapidly"
  homepage "https://naturalintelligence.github.io/fast-xml-parser/"
  url "https://registry.npmjs.org/fast-xml-parser/-/fast-xml-parser-5.2.2.tgz"
  sha256 "2b62c27346b0e79d38d6b0bedecc438760253c98ca5a00fab373d083bb415983"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9ff2dad620eedf4c7de8d39a4c1eefcd246b2ef6a784e2cb20b18fc1f6d4de7e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ce2d8c8b88dc096ddafd757643fe01b3af071cd8f72e4c7e41ab2d70794124ae"
    sha256 cellar: :any_skip_relocation, ventura:       "bf6266ad89f3eadc118eec789a583a40b06c4fdd52d3df5d52d0fe3f7fc229a4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e4c60973c25d2aaf448f943211a5f38c993f1bf5588dd08a79ce222a8ed7466c"
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
