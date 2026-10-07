class Tars < Formula
  desc "Local-first autonomous AI supervisor and sidekick powered by Google Gemini"
  homepage "https://github.com/agustinsacco/tars"
  url "https://registry.npmjs.org/@saccolabs/tars/-/tars-1.51.0.tgz"
  sha256 "359c70966abb4fc49f85236e2b3da19866cb02d916a6310fd7ddc96df5aeef20"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "8b66761c896bc6a8048566bb1f49338f879a7a07640709e0962479b817270d0e"
    sha256 cellar: :any,                 arm64_sequoia: "8b66761c896bc6a8048566bb1f49338f879a7a07640709e0962479b817270d0e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e9d143267fad78290666fdc99956833f2c42834a20e8a55fda818663c9d69eef"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7d6d57c9c8dc99a44ba18160e7198872a4b72832d515dc4dc0cfd9f6399f3827"
  end

  depends_on "node"

  deny_network_access!

  def fetch
    system "npm", "install", *std_npm_args(prefix: buildpath/"npm-fetch")
  end

  def install
    rm_r buildpath/"npm-fetch"
    system "npm", "install", "--offline", *std_npm_args
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

    os = OS.kernel_name.downcase
    arch = Hardware::CPU.intel? ? "x64" : Hardware::CPU.arch.to_s
    native_esbuild = "#{os}-#{arch}"
    nm.glob("**/@esbuild/*").each do |package|
      rm_r(package) if package.basename.to_s != native_esbuild
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
