class LlxprtCode < Formula
  desc "Open-source multi-provider AI assisted CLI development tool"
  homepage "https://github.com/vybestack/llxprt-code"
  url "https://registry.npmjs.org/@vybestack/llxprt-code/-/llxprt-code-0.9.3.tgz"
  sha256 "fd673a16c4f9706936d8f181a7ec83347d764830237f3c842ae7e21f98bc271b"
  license "Apache-2.0"

  depends_on "tree-sitter-cli" => :build
  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")

    # Remove prebuilds for non-native architectures and problematic .so files
    nm = libexec/"lib/node_modules/@vybestack/llxprt-code/node_modules"
    if Hardware::CPU.arm?
      nm.glob("**/prebuilds/darwin-x64").each(&:rmtree)
      nm.glob("**/prebuilds/linux-x64").each(&:rmtree)
    else
      nm.glob("**/prebuilds/darwin-arm64").each(&:rmtree)
      nm.glob("**/prebuilds/prebuild-macOS-ARM64").each(&:rmtree)
      nm.glob("**/prebuilds/linux-arm64").each(&:rmtree)
    end
    %w[c cpp go java json python ruby rust].each do |language|
      path = nm/"@ast-grep/lang-#{language}"
      cd path do
        system "tree-sitter", "build", "-o", "parser.so"
      end
    end
    nm.glob("@ast-grep/lang-*/prebuilds").each { |path| rm_r path }
    nm.glob("**/clipboardy/fallbacks/linux/xsel").each(&:rmtree)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/llxprt --version")
  end
end
