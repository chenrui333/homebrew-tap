class Hapi < Formula
  desc "Agentic coding - access coding agent anywhere"
  homepage "https://github.com/tiann/hapi"
  url "https://registry.npmjs.org/@twsxtd/hapi/-/hapi-0.3.2.tgz"
  sha256 "d864ae86e33d57db35a28a8e738ab577ef43463413a1a691c4f7ef9a96d82ee2"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256                               arm64_tahoe:   "9d4f7f8bad28ece20aeb6df7962f8d9997f8bc17fa0f58491f7eeaca365391da"
    sha256                               arm64_sequoia: "9d4f7f8bad28ece20aeb6df7962f8d9997f8bc17fa0f58491f7eeaca365391da"
    sha256                               arm64_sonoma:  "9d4f7f8bad28ece20aeb6df7962f8d9997f8bc17fa0f58491f7eeaca365391da"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ed5d8d3cb71f049a84559604d29fca68d5a5cf332a34707e78c3b73a2fdcbdbd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "10599bd0b5b3acebb04c97b0dbb74903599916a6a99bd828653d955645ac11ed"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/hapi --version")
    assert_match "📋 Basic Information", shell_output("#{bin}/hapi doctor")
  end
end
