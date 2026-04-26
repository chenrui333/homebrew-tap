class LlxprtCode < Formula
  desc "Open-source multi-provider AI assisted CLI development tool"
  homepage "https://github.com/vybestack/llxprt-code"
  url "https://registry.npmjs.org/@vybestack/llxprt-code/-/llxprt-code-0.9.3.tgz"
  sha256 "fd673a16c4f9706936d8f181a7ec83347d764830237f3c842ae7e21f98bc271b"
  license "Apache-2.0"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any,                 arm64_tahoe:   "57df7f6951bd90d7d602103868f09108dbf1b1675274f4ab4e263088be752993"
    sha256 cellar: :any,                 arm64_sequoia: "c08b11d3dc16e699d636ec5e9ed5612aae2e729af9c55927619808db5ec42955"
    sha256 cellar: :any,                 arm64_sonoma:  "0e0b46be156a57a2bee9a11caece1bb7fe7bf5d9145e2054a1165210489d94ea"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fd048d0c89d375c4f18767da45035337e64035427098ced6d4746fdbcef79b46"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ce8a54352ac1bdf57e4ce8abc34f861214f8a7d9aff69d516cc32fb43d4348f1"
  end

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
