class Ccapi < Formula
  desc "Claude Code Commands Manager"
  homepage "https://github.com/4xian/claude-auto-api"
  url "https://registry.npmjs.org/@4xian/ccapi/-/ccapi-1.0.6.tgz"
  sha256 "7c9e54023dd10c8d612e5eb492ecf2ca0a721dbd2b03d76f167f96b69bc7a9b6"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9156da478220858054f27f58acdb068de01bed77cf45afd76e3ac13a3b32d057"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4b794f52826678d1bded107126b275d7f3e73aed891a81be9cdf90dff6f982d9"
    sha256 cellar: :any_skip_relocation, ventura:       "e377e65980cd4eb3ad1d9007274cf6a25639d1a417901c29357c1a28499b515c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "47a5209d0506617783d65e4868c114d479bad325e8a784a4dc14dbbc61456501"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ccapi --version")

    output = shell_output("#{bin}/ccapi list 2>&1", 1)
    assert_match "未设置settings.json路径", output
  end
end
