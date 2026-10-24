class YoutubeMusicCli < Formula
  desc "Terminal user interface music player for YouTube Music"
  homepage "https://involvex.github.io/youtube-music-cli/"
  url "https://github.com/involvex/youtube-music-cli/archive/refs/tags/v0.3.4.tar.gz"
  sha256 "8812ac635df19ce5bab08b1bf12fdf34201241d65b8433bdff5a711295a470b5"
  license "MIT"
  head "https://github.com/involvex/youtube-music-cli.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9c027786bb316fc1dae3e54b78b229d7b72ddfe85b634db42bf365daff2886d4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ecafdd76a622403d24a1ca07cd4e89c5c6b21edc422b4ee9fd37fd3a623005d3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fad6161b572da7391979af54c12c0ff43082dfd3659b7a2afed2512b67482dc0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "243c044c8dd7e8a207f3bbd0d4f967e2c4268e8687a5f74062713e76ea731a77"
  end

  depends_on "homebrew/core/bun"
  depends_on "mpv"
  depends_on "node"
  depends_on "yt-dlp"

  deny_network_access!

  def fetch
    system "npm", "install", "--include=dev", "--legacy-peer-deps",
           *std_npm_args(prefix: false, ignore_scripts: false)
    system "npm", "install", *std_npm_args(prefix: buildpath/"npm-fetch")
  end

  def install
    system formula_opt_bin("homebrew/core/bun")/"bun", "run", "build"
    system "npm", "install", "--offline", *std_npm_args

    notifier_app = "lib/node_modules/@involvex/youtube-music-cli/node_modules/" \
                   "node-notifier/vendor/mac.noindex/terminal-notifier.app"
    rm_r libexec/notifier_app, force: true
    bin.install_symlink libexec/"bin/youtube-music-cli"
    bin.install_symlink libexec/"bin/ymc"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/youtube-music-cli --version")
    assert_match(/plugins?/i, shell_output("#{bin}/youtube-music-cli plugins list 2>&1"))
  end
end
