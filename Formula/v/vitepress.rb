class Vitepress < Formula
  desc "Is a Vue-powered static site generator"
  homepage "https://vitepress.dev/"
  url "https://registry.npmjs.org/vitepress/-/vitepress-1.6.4.tgz"
  sha256 "37f38a64e1e8ea1e9db68ad201488327c8df1303d3cdb2ceb0e3754259d65114"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any,                 arm64_sequoia: "c4c41cc91674d326a6e454b24f1c34d4c12ea38949b1aa5a7620065807b44f70"
    sha256 cellar: :any,                 arm64_sonoma:  "b2559ee9dbcf678db2b3c4b59e5aadae16c6b904ae2616e5eb61274af3ce3fde"
    sha256 cellar: :any,                 ventura:       "9b41182e509e90434c33914df121b22e64ec8899c48699f3f7f87d20544c001a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "976b585e05a0022a13960b6edfcde8ae774cc3266425096a227600ec73ba32a4"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    output_log = testpath/"output.log"
    pid = spawn bin/"vitepress", [:out, :err] => output_log.to_s
    sleep 1
    assert_match "Network\e[22m\e[2m: use \e[22m\e[1m--host\e[22m\e[2m to expose", output_log.read
  ensure
    Process.kill("TERM", pid)
    Process.wait(pid)
  end
end
