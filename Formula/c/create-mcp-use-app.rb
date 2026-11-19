class CreateMcpUseApp < Formula
  desc "Project scaffolding tool for mcp-use applications"
  homepage "https://github.com/mcp-use/mcp-use"
  url "https://registry.npmjs.org/create-mcp-use-app/-/create-mcp-use-app-2.1.2.tgz"
  sha256 "3ea348a59eb715f5b75986297333f0805350588f5c50f7cd656224d8f40a0295"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, all: "5fda2770844602eced536569a851972f19c9f1e9ee517ecd1cb6d9a6b0b65a78"
  end

  depends_on "node"

  deny_network_access!

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/create-mcp-use-app --version")

    # create a test app
    system bin/"create-mcp-use-app", "test-app", "--template", "starter", "--no-install", "--no-skills",
           "--sdk-version", "1.34.0"
    assert_path_exists testpath/"test-app/package.json"
  end
end
