class CcBridge < Formula
  desc "Live JSONL message bridge between local Claude Code sessions"
  homepage "https://github.com/Incultnitollc/claude-code-live-bridge"
  url "https://registry.npmjs.org/@incultnitollc/cc-bridge/-/cc-bridge-0.1.0.tgz"
  sha256 "803e6d257e03cb628523071070b8f15e3b0687c581ab64897438c0de82b2a087"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, all: "f81e82ea342fa2bdfcedf8315dea20395ec9fb811d7f95ef501b64f5adeaef22"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    assert_match "cc-bridge", shell_output("#{bin}/cc-bridge --help")
  end
end
