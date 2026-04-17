class GetShitDoneCc < Formula
  desc "Meta-prompting and context engineering system for AI coding agents"
  homepage "https://github.com/gsd-build/get-shit-done"
  url "https://github.com/gsd-build/get-shit-done/archive/refs/tags/v1.37.0.tar.gz"
  sha256 "c0fd3b784023f8a3c9004b3a71c1e615314656091305b9e96b26accd747b2d09"
  license "MIT"
  head "https://github.com/gsd-build/get-shit-done.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, all: "cf0eb9eefe195a090fa7fa6cb6dd70939d283dbd9daae39889a96b9b445b1495"
  end

  depends_on "node"

  def install
    system "npm", "run", "build:hooks"
    libexec.install Dir["*"]
    node_modules = libexec/"node_modules"
    node_modules.mkpath
    (bin/"get-shit-done-cc").write_env_script libexec/"bin/install.js",
                                              PATH: "#{Formula["node"].opt_bin}:$PATH"
  end

  test do
    output = shell_output("#{bin}/get-shit-done-cc --help")
    assert_match "Get Shit Done", output
    assert_match version.to_s, output
  end
end
