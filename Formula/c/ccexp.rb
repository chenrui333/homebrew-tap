class Ccexp < Formula
  desc "Exploring and managing Claude Code settings and slash commands"
  homepage "https://github.com/nyatinte/ccexp"
  url "https://registry.npmjs.org/ccexp/-/ccexp-4.0.0.tgz"
  sha256 "4050d11d372d06adeafe48da1ca7b2201b4e442fe4b8d6aa1943a17883e758c9"
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
    assert_match version.to_s, shell_output("#{bin}/ccexp --version")
    output = shell_output("#{bin}/ccexp --path #{testpath}")
    assert_match "Create a CLAUDE.md file to get started", output
  end
end
