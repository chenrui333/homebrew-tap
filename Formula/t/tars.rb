class Tars < Formula
  desc "Local-first autonomous AI supervisor and sidekick powered by Google Gemini"
  homepage "https://github.com/agustinsacco/tars"
  url "https://registry.npmjs.org/@saccolabs/tars/-/tars-1.41.1.tgz"
  sha256 "dd4324d65fc3cf2d4c3a826a73c07b141d7cdce6c6b92fd1b901b7e846390d71"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any,                 arm64_tahoe:   "bd3c1b569bf32935a82e2e5b199df9245b7894e85dc2b3e902759f8f52669873"
    sha256 cellar: :any,                 arm64_sequoia: "bd3c1b569bf32935a82e2e5b199df9245b7894e85dc2b3e902759f8f52669873"
    sha256 cellar: :any,                 arm64_sonoma:  "bd3c1b569bf32935a82e2e5b199df9245b7894e85dc2b3e902759f8f52669873"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9e817976f94790e00f152c8c0056de9ac38c1210c57b28eec3c84a2c805e60b3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "495a6945df95e8d27b624be88aae9af82e6dd5e617b07ff9b974c734b6534fd0"
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
