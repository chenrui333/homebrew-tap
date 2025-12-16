class CreateMcpUseApp < Formula
  desc "Project scaffolding tool for mcp-use applications"
  homepage "https://github.com/mcp-use/mcp-use"
  url "https://registry.npmjs.org/create-mcp-use-app/-/create-mcp-use-app-0.9.1.tgz"
  sha256 "e0a45775520a3b61538d1ebd4463e6a6091e7cb3be716caa55918a54c6f93817"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, all: "d91b9103968deb97df57cac802095bbb740ca43603fc4812878c4611df7cf6c3"
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
