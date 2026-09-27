class Tars < Formula
  desc "Local-first autonomous AI supervisor and sidekick powered by Google Gemini"
  homepage "https://github.com/agustinsacco/tars"
  url "https://registry.npmjs.org/@saccolabs/tars/-/tars-1.51.0.tgz"
  sha256 "359c70966abb4fc49f85236e2b3da19866cb02d916a6310fd7ddc96df5aeef20"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any,                 arm64_tahoe:   "cccebf223fddc9f1aeca46fb120ccab505dfd5548ba451e5ec56264aab31bbe1"
    sha256 cellar: :any,                 arm64_sequoia: "cccebf223fddc9f1aeca46fb120ccab505dfd5548ba451e5ec56264aab31bbe1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "dde137d830090c59430d8fb1afce72c67c2fb6155da9506c7d8307f0c951ea80"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "52ffcccebaf21c5420d2128a6321e5a80a7f9daf33eae060ab767af3d3f02ab8"
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
