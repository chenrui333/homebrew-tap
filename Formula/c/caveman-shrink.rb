class CavemanShrink < Formula
  desc "MCP proxy that compresses prose fields in tool catalogs"
  homepage "https://github.com/JuliusBrussee/caveman"
  url "https://registry.npmjs.org/caveman-shrink/-/caveman-shrink-0.1.0.tgz"
  sha256 "2b40eccce35fe8ce145e6c02fe02d192235ab655cb3614244ca98188c04f87a7"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, all: "66b7845450c239d2fd1e19447785dec35d5d9e85f7dce842589a824759c72cd5"
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
