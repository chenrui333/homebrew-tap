class CreateMcpUseApp < Formula
  desc "Project scaffolding tool for mcp-use applications"
  homepage "https://github.com/mcp-use/mcp-use"
  url "https://registry.npmjs.org/create-mcp-use-app/-/create-mcp-use-app-0.4.10.tgz"
  sha256 "0f8376162debc30e34d2200ee9378394605d880d8ed2fa143645ef0f9ef9cb43"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, all: "291de6829c8c15664a3def05554e136be4cde33d1c9ec83f6888c4f374367270"
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
