class CreateMcpUseApp < Formula
  desc "Project scaffolding tool for mcp-use applications"
  homepage "https://github.com/mcp-use/mcp-use"
  url "https://registry.npmjs.org/create-mcp-use-app/-/create-mcp-use-app-0.9.3.tgz"
  sha256 "a9b2ade75fb94ada5d9caff2bc3518cc6c75a95b2e36bbbd0b47df678f82fb1f"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, all: "46ebde2c24ba11f51762204b848a3723d5bec5ff54a9fb2cf15255aec8a668c1"
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
