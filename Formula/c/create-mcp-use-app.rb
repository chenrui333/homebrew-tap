class CreateMcpUseApp < Formula
  desc "Project scaffolding tool for mcp-use applications"
  homepage "https://github.com/mcp-use/mcp-use"
  url "https://registry.npmjs.org/create-mcp-use-app/-/create-mcp-use-app-0.7.2.tgz"
  sha256 "15f706c97829450f23fd7598e4a361bbcf2922a9146ab8cff45ccf7ab98f7394"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, all: "b70020f029f50286f1a3900757a05f62bbe0dd77aedc9d596909b5e6141fdd6d"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/create-mcp-use-app --version")

    # create a test app
    system bin/"create-mcp-use-app", "test-app", "--no-git", "--template", "starter"
    assert_path_exists testpath/"test-app/package.json"
  end
end
