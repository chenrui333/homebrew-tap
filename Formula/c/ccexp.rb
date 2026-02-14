class Ccexp < Formula
  desc "Exploring and managing Claude Code settings and slash commands"
  homepage "https://github.com/nyatinte/ccexp"
  url "https://registry.npmjs.org/ccexp/-/ccexp-4.0.0.tgz"
  sha256 "4050d11d372d06adeafe48da1ca7b2201b4e442fe4b8d6aa1943a17883e758c9"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d2a69d223e6199a6b7cc864d34c237686164c6dd65e7a9ab4106360efb5f7e7b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b41737a667b78a769a92bf720399e8964605066111344deebed925a9005c1ccb"
    sha256 cellar: :any_skip_relocation, ventura:       "d105bc0ee98534da2ed073a0b62c9e6eb52fbd25e24d7943197c66dbc1d510ca"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "62889610ad9eef0a0f1ccb26d98ec885bb12ff060374203b9fa6c35ae4fa2534"
  end

  depends_on "node"

  on_linux do
    depends_on "xsel"
  end

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")

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
