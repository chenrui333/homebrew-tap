class MermaidCli < Formula
  desc "CLI for Mermaid library"
  homepage "https://github.com/mermaid-js/mermaid-cli"
  url "https://registry.npmjs.org/@mermaid-js/mermaid-cli/-/mermaid-cli-11.4.3.tgz"
  sha256 "6731cfe5a2ae5cfe7824534026aaa9c615a6b13c3c3c129e8b8be2b73f256cec"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any,                 arm64_sequoia: "79fc26185163161716a4fa7e74be029d04911382f75e56cd73ccefd6362f66eb"
    sha256 cellar: :any,                 arm64_sonoma:  "c8f0a5a36e02457ea3de8b11663e417c1e0248902179f39b0c6afdacbc618959"
    sha256 cellar: :any,                 ventura:       "b0c0d8015e51c5e58c9d230bb2d761f9e6d9213c7ea83f7d530282250fb051c6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e131fb9f5ebe72fbec6d745cc5c3198cb07136f1d90bb9c192788ca9a8096258"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]

    node_modules = libexec/"lib/node_modules/@mermaid-js/mermaid-cli/node_modules"

    # Remove incompatible pre-built `bare-fs`/`bare-os` binaries
    os = OS.kernel_name.downcase
    arch = Hardware::CPU.intel? ? "x64" : Hardware::CPU.arch.to_s
    node_modules.glob("{bare-fs,bare-os}/prebuilds/*")
                .each { |dir| rm_r(dir) if dir.basename.to_s != "#{os}-#{arch}" }
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mmdc --version")

    (testpath/"diagram.mmd").write <<~EOS
      graph TD;
        A-->B;
        A-->C;
        B-->D;
        C-->D;
    EOS

    output = shell_output("#{bin}/mmdc -i diagram.mmd -o diagram.svg 2>&1", 1)
    assert_match "Could not find Chrome", output
  end
end
