class Vitepress < Formula
  desc "Is a Vue-powered static site generator"
  homepage "https://vitepress.dev/"
  url "https://registry.npmjs.org/vitepress/-/vitepress-1.6.3.tgz"
  sha256 "cd2aeba61d31b35319a434425da574c418a343968f0cd4241376eb092336b731"
  license "MIT"

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
