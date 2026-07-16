class Tars < Formula
  desc "Local-first autonomous AI supervisor and sidekick powered by Google Gemini"
  homepage "https://github.com/agustinsacco/tars"
  url "https://registry.npmjs.org/@saccolabs/tars/-/tars-1.40.0.tgz"
  sha256 "be7bf90ab0bd1a3eea143ba0c72cd4c1bcaf41d65c5e87b6cebbcb2bd6371b8c"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any,                 arm64_tahoe:   "67d8a1ad26b232753e7c4ceae24ba21ed9b07c61b5386c3681db2b76f22c1ae7"
    sha256 cellar: :any,                 arm64_sequoia: "67d8a1ad26b232753e7c4ceae24ba21ed9b07c61b5386c3681db2b76f22c1ae7"
    sha256 cellar: :any,                 arm64_sonoma:  "67d8a1ad26b232753e7c4ceae24ba21ed9b07c61b5386c3681db2b76f22c1ae7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ea116544975adf16abd877b437b17c9f7b16e46adc3e5e0251d27d22af0b3ed7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4953d222329b1f58e9aafa44bf41cf97913cbdd18698ef2190fc7ed214f201fc"
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
