class LlxprtCode < Formula
  desc "Open-source multi-provider AI assisted CLI development tool"
  homepage "https://github.com/vybestack/llxprt-code"
  url "https://registry.npmjs.org/@vybestack/llxprt-code/-/llxprt-code-0.11.0.tgz"
  sha256 "0e17b254510c8bccf61773c74ec2e41e6b599e4bd63653333ee6d485a67e7a67"
  license "Apache-2.0"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256               arm64_tahoe:   "fb1baf788e8d229dc35521f18508abddedfa075049ec92a41999356a52f18b8c"
    sha256               arm64_sequoia: "4ad05039389ad0677ffdb765c080241cd4ebea8b00cb5c8962a61f47d8f7d4ae"
    sha256 cellar: :any, arm64_linux:   "daab94ff51552ba356295714bbcbfcff26de60bbf7eaf772304b0245f3b46ad4"
    sha256 cellar: :any, x86_64_linux:  "e9f87ca6039e70483c5e4523d7120b0a90ef6bdc13eb02e3d1f490c62177039b"
  end

  depends_on "tree-sitter-cli" => :build
  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    app = libexec/"lib/node_modules/@vybestack/llxprt-code"
    # The pinned Bun 1.3.14 runtime crashes while loading Sharp on Linux.
    inreplace app/"package.json", '"bun": "1.3.14"', '"bun": "1.4.2"'
    cd app do
      system "npm", "install", *std_npm_args(prefix: false), "bun@1.4.2"
    end
    inreplace app/"package.json", '"bun": "^1.4.2"', '"bun": "1.4.2"'
    nm = app/"node_modules"
    if OS.linux? && Hardware::CPU.intel?
      # Sharp crashes Bun on Linux x86_64; fail explicitly if optional resizing is requested.
      bundle = app/"bundle/llxprt.js"
      initializer_pattern = /(var init_imageResize\d* = __esm\(\(\) => \{\r?\n)[ \t]*init_dist\(\);\r?\n/
      resize_pattern = /
        (async[ ]function[ ]resizeImageIfNeeded
          \(content,[ ]mimeType,[ ]displayName,[ ]policy\)[ ]\{\r?\n
          [ \t]*if[ ]\(!hasLimits\(policy\)\)[ ]\{\r?\n
          [ \t]*return[ ]content;\r?\n
          [ \t]*\}\r?\n
        )
      /x
      resize_error = "throw new ImageResizeError(displayName, " \
                     "\"image resizing is unavailable on Linux x86_64\");"
      resize_replacement = "\\1  #{resize_error}\n"
      inreplace bundle do |s|
        raise "Missing image resize initializer" unless s.gsub!(initializer_pattern, '\\1')
        raise "Missing image resize function" unless s.gsub!(resize_pattern, resize_replacement)
      end
    end
    cd nm/"bun" do
      system "node", "install.js"
    end
    bin.install_symlink libexec.glob("bin/*")

    # Remove prebuilds for non-native architectures and problematic .so files
    if Hardware::CPU.arm?
      nm.glob("**/prebuilds/darwin-x64").each(&:rmtree)
      nm.glob("**/prebuilds/ios-x64-simulator").each(&:rmtree)
      nm.glob("**/prebuilds/linux-x64").each(&:rmtree)
    else
      nm.glob("**/prebuilds/darwin-arm64").each(&:rmtree)
      nm.glob("**/prebuilds/prebuild-macOS-ARM64").each(&:rmtree)
      nm.glob("**/prebuilds/linux-arm64").each(&:rmtree)
    end
    nm.glob("**/prebuilds/android-*").each(&:rmtree)
    if OS.linux?
      node_modules = libexec/"lib/node_modules"
      node_modules.glob("**/@img/sharp-linuxmusl-*").each(&:rmtree)
      node_modules.glob("**/@img/sharp-libvips-linuxmusl-*").each(&:rmtree)
      nm.glob("**/@oven/bun-*-musl*").each(&:rmtree)
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

    output = shell_output("#{bin}/llxprt sample prompt 2>&1", 52)
    assert_match "No provider is configured.", output
  end
end
