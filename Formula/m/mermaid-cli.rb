class MermaidCli < Formula
  desc "CLI for Mermaid library"
  homepage "https://github.com/mermaid-js/mermaid-cli"
  url "https://registry.npmjs.org/@mermaid-js/mermaid-cli/-/mermaid-cli-11.6.0.tgz"
  sha256 "931a41e109b7d33d0da4881a4cef673f6d77b30219543f7496c5c003c64866df"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any,                 arm64_sequoia: "83a2bfc8ea080ec1f5b2ac653270dfcafb4503780c2728d3f422e0e8c22f15b0"
    sha256 cellar: :any,                 arm64_sonoma:  "8ef3cd85c1f01e7fdfa95cf7048b547deeedbcb52e4efe0e6b5a59545915dada"
    sha256 cellar: :any,                 ventura:       "746b9f5d97610e14f970c9e6ee23e83ad5d1dc5943bb3da0261ff0e868df5186"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a313e675c64944b1e585f4dd334965dafed08999533ecf62b3565a86545ee7c1"
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
