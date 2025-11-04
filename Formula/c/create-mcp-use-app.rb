class CreateMcpUseApp < Formula
  desc "Project scaffolding tool for mcp-use applications"
  homepage "https://github.com/mcp-use/mcp-use"
  url "https://registry.npmjs.org/create-mcp-use-app/-/create-mcp-use-app-0.4.9.tgz"
  sha256 "9495d7f99acf79ff095ffea9ab689c43884f2b8cccf187b736c206dcc792b8f1"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, all: "45a7e746511db383be86ca26b4e98863130d492a854acfdca3470e784917680c"
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
