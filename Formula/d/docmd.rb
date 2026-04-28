class Docmd < Formula
  desc "Minimal Markdown documentation generator"
  homepage "https://docmd.mgks.dev/"
  url "https://registry.npmjs.org/@mgks/docmd/-/docmd-0.2.4.tgz"
  sha256 "ae59d70963141befee3f9920831422066ac890778deb76a0e9b8bd378a1a5fc5"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6da3af0ffdc96a9a9ea0b4a3e093df946460056629414b90d18cacc6a32ca4fc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "878b4093259cfe46cd3febdc8a16733c223d27bd810d729024509ff7ab1703e5"
    sha256 cellar: :any_skip_relocation, ventura:       "a3552fac437ca76a0a1fc77564ed42ae9a4b4454b5a28cc0cd0d487e31205242"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "47fc3f74dcc22378688ea9ec161a2b962272ae0c5cd7732cf188233647301eed"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/docmd --version")

    system bin/"docmd", "init"
    assert_path_exists testpath/"config.js"
    assert_match "title: \"Welcome\"", (testpath/"docs/index.md").read
  end
end
