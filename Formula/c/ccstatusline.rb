class Ccstatusline < Formula
  desc "Beautiful highly customizable statusline for Claude Code CLI"
  homepage "https://github.com/sirmalloc/ccstatusline"
  url "https://registry.npmjs.org/ccstatusline/-/ccstatusline-2.0.12.tgz"
  sha256 "8bf89e7644d94d39111e017ba5f61e2e469ced6c23010a63e85f1f562d1dfae2"
  license "MIT"

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    output_log = testpath/"output.log"
    pid = spawn bin/"ccstatusline", testpath, [:out, :err] => output_log.to_s
    sleep 1
    assert_match version.to_s, output_log.read
    assert_match "Main Menu", output_log.read
  ensure
    Process.kill("TERM", pid)
    Process.wait(pid)
  end
end
