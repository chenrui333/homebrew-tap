class Cgpu < Formula
  desc "CLI enabling free cloud GPU access in your terminal for learning CUDA"
  homepage "https://github.com/RohanAdwankar/cgpu"
  url "https://registry.npmjs.org/cgpu/-/cgpu-0.1.3.tgz"
  sha256 "1716420d6b30833402a3371986490791f26afce6fc128edc35000c53a0d835b6"
  license "Apache-2.0"

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match "Cloud GPU CLI", shell_output("#{bin}/cgpu --help")
  end
end
