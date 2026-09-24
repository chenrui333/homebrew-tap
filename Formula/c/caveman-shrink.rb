class CavemanShrink < Formula
  desc "MCP proxy that compresses prose fields in tool catalogs"
  homepage "https://github.com/JuliusBrussee/caveman"
  url "https://registry.npmjs.org/caveman-shrink/-/caveman-shrink-0.1.1.tgz"
  sha256 "690edb8a2c7e8b78c1a4209bd5f73e85b14fdc5c2ad6943479abb3d9da30f593"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, all: "fdc1507dd4744c8788d6045e91f79d07acf3cac528b907bc52114df74055f6b4"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    assert_match "missing upstream command",
                 shell_output("#{bin}/caveman-shrink 2>&1", 2)

    (testpath/"fake.js").write <<~JS
      const msg = {
        jsonrpc: "2.0",
        id: 1,
        result: {
          tools: [{
            name: "demo",
            description: "Please just fetch the user data"
          }]
        }
      };
      process.stdout.write(JSON.stringify(msg) + "\\n");
    JS

    output = shell_output("#{bin}/caveman-shrink node #{testpath}/fake.js")
    refute_match(/please/i, output)
    assert_match "demo", output
  end
end
