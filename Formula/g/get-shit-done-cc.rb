class GetShitDoneCc < Formula
  desc "Meta-prompting and context engineering system for AI coding agents"
  homepage "https://github.com/gsd-build/get-shit-done"
  url "https://github.com/gsd-build/get-shit-done/archive/refs/tags/v1.36.0.tar.gz"
  sha256 "f5b03c91cdddef9d64624bb31fff6697e2fbd1292b6bb4270c9aedc5ab8b8d03"
  license "MIT"
  head "https://github.com/gsd-build/get-shit-done.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, all: "dfd306cad6e2b48d980d590a9790e230dc665292aecfccf67d0170a11414d022"
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
