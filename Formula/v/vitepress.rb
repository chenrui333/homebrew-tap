class Vitepress < Formula
  desc "Is a Vue-powered static site generator"
  homepage "https://vitepress.dev/"
  url "https://registry.npmjs.org/vitepress/-/vitepress-1.6.3.tgz"
  sha256 "cd2aeba61d31b35319a434425da574c418a343968f0cd4241376eb092336b731"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any,                 arm64_sequoia: "d360524ab895c8384ac3d72b663e9dc41702e92179c17637a97a428f68ebe1ce"
    sha256 cellar: :any,                 arm64_sonoma:  "883d4e68fd201772aaa8394470edd6018c062b1d0deb92fc56e5bac4401576af"
    sha256 cellar: :any,                 ventura:       "148bbac77093eca22a02d2a863d2a0968dc723abcd54979d25fa60e76b034dad"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8d85672d5ca5c786b5f6567f41c09ce58285367f0f8a2a07ac85c82fcde177f9"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
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
