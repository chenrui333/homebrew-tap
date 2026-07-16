class Tars < Formula
  desc "Local-first autonomous AI supervisor and sidekick powered by Google Gemini"
  homepage "https://github.com/agustinsacco/tars"
  url "https://registry.npmjs.org/@saccolabs/tars/-/tars-1.40.0.tgz"
  sha256 "be7bf90ab0bd1a3eea143ba0c72cd4c1bcaf41d65c5e87b6cebbcb2bd6371b8c"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any,                 arm64_tahoe:   "c276c4968337ac2cfda1cf963e1c52e14bfb03c8bebd06bd39995502cb7261e0"
    sha256 cellar: :any,                 arm64_sequoia: "5c405e6d10cf82525561ed78be85f9f67530e4cd9f6098122837c41996e58acf"
    sha256 cellar: :any,                 arm64_sonoma:  "5c405e6d10cf82525561ed78be85f9f67530e4cd9f6098122837c41996e58acf"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5a7a882dd0d67a86027281a5a0f7043d718fb65ca1d4f93940e9f0c4d254aa22"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2cc3af5581653742bf11e92f30ee87c9f8969257c221e86572c085a9e1facd81"
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
