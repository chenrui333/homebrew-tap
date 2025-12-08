class Codebuff < Formula
  desc "Generate code from the terminal"
  homepage "https://www.codebuff.com/"
  url "https://registry.npmjs.org/codebuff/-/codebuff-1.0.544.tgz"
  sha256 "9abd6ebbe0cef57393315e37e8e5d8dbf96149380c402afa7aa656f2307a40c4"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, all: "079f004ec294c9b076b4e0e8ddfddd37ddd6ce9a5e927d814206cd1b35955700"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/cb --version")

    output_log = testpath/"output.log"
    pid = spawn bin/"cb", testpath, [:out, :err] => output_log.to_s
    sleep 1
    assert_match "Codebuff will run commands on your behalf to help you build", output_log.read
  ensure
    Process.kill("TERM", pid)
    Process.wait(pid)
  end
end
