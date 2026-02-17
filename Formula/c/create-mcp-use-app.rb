class CreateMcpUseApp < Formula
  desc "Project scaffolding tool for mcp-use applications"
  homepage "https://github.com/mcp-use/mcp-use"
  url "https://registry.npmjs.org/create-mcp-use-app/-/create-mcp-use-app-0.13.1.tgz"
  sha256 "c8bdf468d7bc04d49ff3d78d315673fbc739401a96ccb16013585663a913646e"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, all: "8f11b9b743bd044eb1b84ed0d69306071129ba354a3ec6b76fb8b6d81a4206d7"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/create-mcp-use-app --version")

    # create a test app
    system bin/"create-mcp-use-app", "test-app", "--no-git", "--template", "starter"
    assert_path_exists testpath/"test-app/package.json"
  end
end
