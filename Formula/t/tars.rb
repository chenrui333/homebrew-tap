class Tars < Formula
  desc "Local-first autonomous AI supervisor and sidekick powered by Google Gemini"
  homepage "https://github.com/agustinsacco/tars"
  url "https://registry.npmjs.org/@saccolabs/tars/-/tars-1.43.0.tgz"
  sha256 "f0bd0a23396f7e0ae17677ba0e132c14b0e1c9f59d74f4969f37b86da1043adb"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any,                 arm64_tahoe:   "ddbb07aea89ac9d0122f12fb033c6cb213f9dc1a9c8d846c159e1db15c61f630"
    sha256 cellar: :any,                 arm64_sequoia: "ddbb07aea89ac9d0122f12fb033c6cb213f9dc1a9c8d846c159e1db15c61f630"
    sha256 cellar: :any,                 arm64_sonoma:  "ddbb07aea89ac9d0122f12fb033c6cb213f9dc1a9c8d846c159e1db15c61f630"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e62f6a2f5b9322194bff7349c60b3e6833841edd1c8c3f1aba242e3c40f8b1a3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6a4381635066d7d43d667c61fdbbee18c6778a4b97265dce968c9b577f3a4640"
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
