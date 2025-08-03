class CarbonNowCli < Formula
  desc "Beautiful images of your code — from right inside your terminal"
  homepage "https://github.com/mixn/carbon-now-cli"
  url "https://registry.npmjs.org/carbon-now-cli/-/carbon-now-cli-2.1.0.tgz"
  sha256 "7ad51db24caf6b79d77d9ee4407bee6a5ed0c6677014ae5ba0fb955fb7770083"
  license "MIT"

  depends_on "node"

  on_linux do
    depends_on "xsel"
  end

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]

    clipboardy_fallbacks_dir = libexec/"lib/node_modules/#{name}/node_modules/clipboardy/fallbacks"
    rm_r(clipboardy_fallbacks_dir) # remove pre-built binaries
    if OS.linux?
      linux_dir = clipboardy_fallbacks_dir/"linux"
      linux_dir.mkpath
      # Replace the vendored pre-built xsel with one we build ourselves
      ln_sf (Formula["xsel"].opt_bin/"xsel").relative_path_from(linux_dir), linux_dir
    end
  end

  test do
    output = shell_output("#{bin}/carbon-now 2>&1", 1)
    assert_match "No file or stdin given.", output
  end
end
