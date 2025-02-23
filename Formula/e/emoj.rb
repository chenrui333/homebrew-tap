class Emoj < Formula
  desc "Find relevant emoji from text on the command-line"
  homepage "https://github.com/yeoman/emoj"
  url "https://registry.npmjs.org/emoj/-/emoj-4.1.0.tgz"
  sha256 "18ef4b06e9ab7dff8dfb15257bf6e9110d3c6842fa0285728d9e4e3c0a0ad298"
  license "MIT"

  depends_on "node"

  on_linux do
    depends_on "xsel"
  end

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec/"bin/emoj"

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
    assert_match version.to_s, shell_output("#{bin}/emoj --version")
    assert_match "🦄", shell_output("#{bin}/emoj unicorn")
  end
end
