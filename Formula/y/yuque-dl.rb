class YuqueDl < Formula
  desc "Knowledge base downloader for Yuque"
  homepage "https://github.com/gxr404/yuque-dl"
  url "https://registry.npmjs.org/yuque-dl/-/yuque-dl-1.0.81.tgz"
  sha256 "41039640509fd213938a7c412fec8a43492d52d30bf3fbdcf5f34c905c7a5b8c"
  license "ISC"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "28645d23494751f42e65c3b6d8a051d1b5e6a19361b635c065256d8986aff8d2"
    sha256 cellar: :any,                 arm64_sequoia: "4d8a7d310ada3d8689f0feb123b79969f9c09424e17adaf4c78c707ba935221a"
    sha256 cellar: :any,                 arm64_sonoma:  "77b931e0ee707ecd99810007ce21536e58f88434cdd7d44cbdccf5bedd17de59"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7859fda5440c4d6c3d78e2038e02fce2e6deee3f4cec3c275587a6f187a48a36"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/yuque-dl --version")

    assert_match "Please enter a valid URL", shell_output("#{bin}/yuque-dl test 2>&1", 1)
  end
end
