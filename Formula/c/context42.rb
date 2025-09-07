class Context42 < Formula
  desc "Best code style guide is the one your team already follows"
  homepage "https://github.com/zenbase-ai/context42"
  url "https://registry.npmjs.org/context42/-/context42-0.3.3.tgz"
  sha256 "48534ea885d58e2b50727f5f142df76eceffc35c690b38230b89955b88edddca"
  license "MIT"

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/context42 --version")

    output = shell_output("#{bin}/context42 --debug 2>&1", 1)
    assert_match "GEMINI_API_KEY environment variable is not set", output
  end
end
