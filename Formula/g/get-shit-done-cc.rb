class GetShitDoneCc < Formula
  desc "Meta-prompting and context engineering system for AI coding agents"
  homepage "https://github.com/gsd-build/get-shit-done"
  url "https://github.com/gsd-build/get-shit-done/archive/refs/tags/v1.38.5.tar.gz"
  sha256 "8792fbf91528d47219e84061c9ec09b4013fb554f63ec577e9ee18c237859338"
  license "MIT"
  head "https://github.com/gsd-build/get-shit-done.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, all: "2bc378f72e548b02e6b2b87a5a4d7a2091a64c08d746b09418c3e21a3dd07f7b"
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
