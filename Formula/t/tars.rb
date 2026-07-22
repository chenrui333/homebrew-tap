class Tars < Formula
  desc "Local-first autonomous AI supervisor and sidekick powered by Google Gemini"
  homepage "https://github.com/agustinsacco/tars"
  url "https://registry.npmjs.org/@saccolabs/tars/-/tars-1.44.0.tgz"
  sha256 "a617df66e227122e9d6bf931e432ec46f62e37ebd195a7c07b516000efd24c11"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any,                 arm64_tahoe:   "bb871d63e47ab9e9f9c61238bdd9ae3fbea1549e8d0874f8134082d7e020fcfd"
    sha256 cellar: :any,                 arm64_sequoia: "bb871d63e47ab9e9f9c61238bdd9ae3fbea1549e8d0874f8134082d7e020fcfd"
    sha256 cellar: :any,                 arm64_sonoma:  "bb871d63e47ab9e9f9c61238bdd9ae3fbea1549e8d0874f8134082d7e020fcfd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c1e858e3dc2eca3474f22d775ad0f270c926b954387b800124f51d592bbef0e0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9e5284119b4f1bc67d48084a4e7bb4f75fdeb8a5a3efa27a76f35db954b8e9f3"
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
