class CreateMcpUseApp < Formula
  desc "Project scaffolding tool for mcp-use applications"
  homepage "https://github.com/mcp-use/mcp-use"
  url "https://registry.npmjs.org/create-mcp-use-app/-/create-mcp-use-app-2.0.9.tgz"
  sha256 "954476a2146e049e0ca3ba195584a0b6a1a62b926eaa58c4b17f442efcceabbc"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, all: "785b44773605dc0ca2d97c64f9d04155f30332cc461b9851488b78cb969c4ea5"
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
