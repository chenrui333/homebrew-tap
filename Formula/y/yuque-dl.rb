class YuqueDl < Formula
  desc "Knowledge base downloader for Yuque"
  homepage "https://github.com/gxr404/yuque-dl"
  url "https://registry.npmjs.org/yuque-dl/-/yuque-dl-1.0.75.tgz"
  sha256 "39d00f2bb4c8aada7dda61b0f799186fb025c025f5aaacf4551024617ade56f8"
  license "ISC"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any,                 arm64_sequoia: "e667620bb44fec17635a22350bed20c2f197ded461792d7d25b36f3c63cb518d"
    sha256 cellar: :any,                 arm64_sonoma:  "226e9879058ac484ff8d62c3182552a5d36730cc6be71879384fc5a1601c17de"
    sha256 cellar: :any,                 ventura:       "c9c1e2c19626895a812c7d1d9ee37a5aa7afd7eec8fbfabe0a65f395741d1fd1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "681b981ea8c2fb23e65da40442b4a88ff02e58ccaa7f40226ce3aad3306c9389"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec/"bin/yuque-dl"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/yuque-dl --version")

    assert_match "Please enter a valid URL", shell_output("#{bin}/yuque-dl test 2>&1", 1)
  end
end
