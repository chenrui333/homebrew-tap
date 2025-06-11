class MermaidCli < Formula
  desc "CLI for Mermaid library"
  homepage "https://github.com/mermaid-js/mermaid-cli"
  url "https://registry.npmjs.org/@mermaid-js/mermaid-cli/-/mermaid-cli-11.4.3.tgz"
  sha256 "6731cfe5a2ae5cfe7824534026aaa9c615a6b13c3c3c129e8b8be2b73f256cec"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any,                 arm64_sequoia: "1f1b29d26a1ba6c82f3499788d8e906b9847376c5e9fed1c2d67a9b3c969b00b"
    sha256 cellar: :any,                 arm64_sonoma:  "eef488faa75116e31252da98265578b653b5798b3803646d364dca060a37046a"
    sha256 cellar: :any,                 ventura:       "14c018e154f2c3d687bac21fe01f680d7d5e7a031acc2afacc81420188492776"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d5b6c57106eaa831132a0afba0174fa18faa061f48b5d0ada5061b0492c9a767"
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
