class Tars < Formula
  desc "Local-first autonomous AI supervisor and sidekick powered by Google Gemini"
  homepage "https://github.com/agustinsacco/tars"
  url "https://registry.npmjs.org/@saccolabs/tars/-/tars-1.44.0.tgz"
  sha256 "a617df66e227122e9d6bf931e432ec46f62e37ebd195a7c07b516000efd24c11"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any,                 arm64_tahoe:   "6aec9a705ec5a9f16dd1d69c4da5426ecf1154b503273d54f7fb1400c063d00b"
    sha256 cellar: :any,                 arm64_sequoia: "6aec9a705ec5a9f16dd1d69c4da5426ecf1154b503273d54f7fb1400c063d00b"
    sha256 cellar: :any,                 arm64_sonoma:  "6aec9a705ec5a9f16dd1d69c4da5426ecf1154b503273d54f7fb1400c063d00b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1e4730e055e78d388b801df2df328c9370166c41741d66280a9051ee34f66409"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0a0e5f9bd6305e3d8e798fd39e6a2eb6e782851fc16f3fa8572665710cbd4cfc"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")

    # Remove prebuilds to avoid linkage issues
    nm = libexec/"lib/node_modules/@saccolabs/tars/node_modules"
    if OS.linux?
      nm.glob("**/prebuilds").each { |dir| rm_r(dir) }
    else
      native = "darwin-#{(Hardware::CPU.arch == :arm64) ? "arm64" : "x64"}"
      nm.glob("**/prebuilds/*").each do |dir|
        rm_r(dir) if dir.basename.to_s != native
      end
    end

    arch = Hardware::CPU.intel? ? "x64" : Hardware::CPU.arch.to_s
    native_clipboard = if OS.mac?
      "clipboard-darwin-#{arch}"
    else
      "clipboard-linux-#{arch}-gnu"
    end
    nm.glob("**/@mariozechner/clipboard-*").each do |dir|
      rm_r(dir) if dir.basename.to_s != native_clipboard
    end

    if OS.mac?
      nm.glob("**/@mariozechner/#{native_clipboard}/clipboard.*.node").each do |native_module|
        clipboard_module = libexec/"clipboard.node"
        mv native_module, clipboard_module
        native_module.make_symlink clipboard_module.relative_path_from(native_module.dirname)
      end
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/tars --version")

    assert_match "No secrets stored.", shell_output("#{bin}/tars secret list")
  end
end
