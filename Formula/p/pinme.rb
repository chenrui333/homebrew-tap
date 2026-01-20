class Pinme < Formula
  desc "Deploy Your Frontend in a Single Command"
  homepage "https://pinme.eth.limo/"
  url "https://registry.npmjs.org/pinme/-/pinme-1.2.2.tgz"
  sha256 "fc1e4bc263dba4f24973e9af350ee6f8e7d30a3fdc1c2f7f11024b15578525f9"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, all: "69e854c3001bb4a5ddb1a92f13c99f04200230192668f7ad1be9a48cc8a4f87e"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/pinme --version")
    assert_match "Failed to fetch domains: Auth not set", shell_output("#{bin}/pinme domain")
    assert_match "No upload history found", shell_output("#{bin}/pinme ls")
  end
end
