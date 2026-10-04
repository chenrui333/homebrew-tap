class CreateMcpUseApp < Formula
  desc "Project scaffolding tool for mcp-use applications"
  homepage "https://github.com/mcp-use/mcp-use"
  url "https://registry.npmjs.org/create-mcp-use-app/-/create-mcp-use-app-2.0.8.tgz"
  sha256 "21025f380ba863357626fdab9ab5e6241788beb65cd9e119407af3d7c09e682a"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, all: "346f81bbb188aaff44bbbc63c1889eb169214f48c2a6785cb1a59a1389d2d649"
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
