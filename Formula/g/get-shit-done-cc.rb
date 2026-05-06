class GetShitDoneCc < Formula
  desc "Meta-prompting and context engineering system for AI coding agents"
  homepage "https://github.com/gsd-build/get-shit-done"
  url "https://github.com/gsd-build/get-shit-done/archive/refs/tags/v1.50.0-canary.2.tar.gz"
  version "1.50.0-canary.2"
  sha256 "a1c5148bfdc2b6b13e98458d0361e70748edb759e625b09e7385362d2f97213c"
  license "MIT"
  head "https://github.com/gsd-build/get-shit-done.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, all: "39a3df6e99134543d824fd95c96665351e10b29a2d9051abe5f8a3f400a667ab"
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
    assert_match(/v\d+\.\d+\.\d+(?:-[\w.]+)?/, output)
  end
end
