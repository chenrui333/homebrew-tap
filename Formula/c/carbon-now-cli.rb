class CarbonNowCli < Formula
  desc "Beautiful images of your code — from right inside your terminal"
  homepage "https://github.com/mixn/carbon-now-cli"
  url "https://registry.npmjs.org/carbon-now-cli/-/carbon-now-cli-2.1.0.tgz"
  sha256 "7ad51db24caf6b79d77d9ee4407bee6a5ed0c6677014ae5ba0fb955fb7770083"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ba895228750739acb0fb6be8f492b7a68b851929dad5824d22bb3e3a7207d6fc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6090b83ca2f3cd6a39f257e9b9a2103af9e28e52907a71920739ae10991a6811"
    sha256 cellar: :any_skip_relocation, ventura:       "bc711cb928cbd6fc99a7c9699d507a71c13a68e90d68a4d54096a6e105c29606"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0ff99900454c51e78daf4369548ad6546b7da9845dccec55c365ef2fc7f5cbfc"
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
    output = shell_output("#{bin}/carbon-now 2>&1", 1)
    assert_match "No file or stdin given.", output
  end
end
