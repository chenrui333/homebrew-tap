class YoutubeMusicCli < Formula
  desc "Terminal user interface music player for YouTube Music"
  homepage "https://involvex.github.io/youtube-music-cli/"
  url "https://github.com/involvex/youtube-music-cli/archive/refs/tags/v0.2.0.tar.gz"
  sha256 "cb2b7827248a3cd075319d618fe697968053fe7dbe0210244aeeab448113c830"
  license "MIT"
  head "https://github.com/involvex/youtube-music-cli.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "37f21d38b7c64be2a8d8ae1750b525e704ff5e17d0217c1a773bcc699ab244ce"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0701e51108b40e403879ea504cdd307bee830b09ad741f8d60ee9b5208415c04"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ec181273e0910479c58d3b714c8c5c9be5b74130bd1e1b49027caf02f3df3edc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "34e0ae77696fa76b53c9dfe43ac9ea4ce3ea9cb18919aca20e5bd40fce7e6dbb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "50f8bcb2ba9b3b6f4d191fed9d32cb0710b248e6e6256d7c2820a99aeba7d7a5"
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
