class Clawra < Formula
  desc "Add selfie superpowers to your OpenClaw agent"
  homepage "https://www.clawra.dev"
  url "https://registry.npmjs.org/clawra/-/clawra-1.1.1.tgz"
  sha256 "ab4469e7ddeb0056061ffff9bf139c98cb71ece80e1ccd1da9db2d48e1cd3a7d"
  license "MIT"
  head "https://github.com/SumeLabs/clawra.git", branch: "main"

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    assert_equal version.to_s,
                 shell_output("node -p \"require('#{libexec}/lib/node_modules/clawra/package.json').version\"").strip

    output = shell_output("#{bin}/clawra 2>&1", 1)
    assert_match "OpenClaw CLI not found!", output
    assert_match "Install with: npm install -g openclaw", output
  end
end
