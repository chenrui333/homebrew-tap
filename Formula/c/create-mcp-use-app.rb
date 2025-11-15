class CreateMcpUseApp < Formula
  desc "Project scaffolding tool for mcp-use applications"
  homepage "https://github.com/mcp-use/mcp-use"
  url "https://registry.npmjs.org/create-mcp-use-app/-/create-mcp-use-app-0.5.0.tgz"
  sha256 "b75bf65dc2f3ebbdd95b637e43eaf2a1136da78564f4140e91c03db41022143b"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, all: "662e6c948615b11a21ee82918dc4ba99ca36a228167aea5f4410363cd42afbe0"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/create-mcp-use-app --version")

    # create a test app
    system bin/"create-mcp-use-app", "test-app", "--no-install", "--no-git", "--template", "starter"
    assert_path_exists testpath/"test-app/package.json"
  end
end
