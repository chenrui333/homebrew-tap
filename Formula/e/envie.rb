class Envie < Formula
  desc "MCP server for Apify"
  homepage "https://github.com/ilmari-h/envie"
  url "https://registry.npmjs.org/@envie/cli/-/cli-0.0.14.tgz"
  sha256 "567e1ab812dfd1292e6f5daf173b636fe544da608171f46d0378c5f3e2be60d8"
  license "Apache-2.0"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "19710220c1d2a420b77a0580675ee48783c9b57cefb3c55dd597959c8eac8c4a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ac19286cb721c17cb38d11ada3b733d46a0b4be3123cf10a9ab23ede206cdc10"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "75ec764614b3df1b0de262fa803d5dd0469b42ce5b4a0864c92ad8dd9bbdb9d2"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match "Error: No authentication token found.", shell_output("#{bin}/envie environment list 2>&1", 1)
    output = shell_output("#{bin}/envie login 2>&1", 1)
    assert_match "Login failed: Please specify which keypair to use", output
  end
end
