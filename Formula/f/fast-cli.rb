class FastCli < Formula
  desc "Test your download and upload speed using fast.com"
  homepage "https://github.com/sindresorhus/fast-cli"
  url "https://registry.npmjs.org/fast-cli/-/fast-cli-5.0.1.tgz"
  sha256 "154cecdfc2f0a0465d6a34dd2b231ada73a24166ef0d7458dd4fb54640f9ffa7"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any,                 arm64_sequoia: "5ac2d8d45854a47715fdfa1cc2d82f265cc68def8ef8b8039b06eb6f4ea67e88"
    sha256 cellar: :any,                 arm64_sonoma:  "cc4d902fc303959041197fdc6d330a6b8a1e038e5f5c4f26d6eca3388ece237a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "850e28091b33b0aca06a02ac17660827d97b95c200207edcf72ba579a22013c4"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]

    node_modules = libexec/"lib/node_modules/fast-cli/node_modules"

    # Remove incompatible pre-built `bare-fs`/`bare-os`/`bare-url` binaries
    os = OS.kernel_name.downcase
    arch = Hardware::CPU.intel? ? "x64" : Hardware::CPU.arch.to_s
    node_modules.glob("{bare-fs,bare-os,bare-url}/prebuilds/*")
                .each { |dir| rm_r(dir) if dir.basename.to_s != "#{os}-#{arch}" }
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/fast --version")
    assert_empty shell_output("#{bin}/fast --upload --json 2>&1").strip
  end
end
