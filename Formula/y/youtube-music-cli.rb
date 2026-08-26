class YoutubeMusicCli < Formula
  desc "Terminal user interface music player for YouTube Music"
  homepage "https://involvex.github.io/youtube-music-cli/"
  url "https://github.com/involvex/youtube-music-cli/archive/refs/tags/v0.1.7.tar.gz"
  sha256 "ad1665a71a068d143d598acaf86745b03cd79ccb2ba8e005b400212e5dbb5834"
  license "MIT"
  head "https://github.com/involvex/youtube-music-cli.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6632793c55d2bbe705cdc91fbd37f7a54ebb2ef622c4515397e08fa62f4d1a5e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "309068b22b58feb6dcff958b3de0d80e87fe4b9914eba2f39f414c881f5e3471"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1ad3a0af3546c1c19f2439dcbfd5dde73abdb026657c94fed97cda6419c43def"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0f80bd0b9c67c80435203a2d9832d5db9d2ffcc59975fadc64d8f85d2ea9e0ac"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fe9659224e4481e26cd8b7d4a1a512ffd8222b8534cc31462f5a54ab94d35d39"
  end

  depends_on "chenrui333/tap/bun"
  depends_on "mpv"
  depends_on "node"
  depends_on "yt-dlp"

  def install
    system "npm", "install", "--include=dev", "--legacy-peer-deps",
           *std_npm_args(prefix: false, ignore_scripts: false)
    system formula_opt_bin("chenrui333/tap/bun")/"bun", "run", "build"
    system "npm", "install", *std_npm_args

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
