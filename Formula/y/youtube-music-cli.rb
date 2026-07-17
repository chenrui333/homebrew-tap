class YoutubeMusicCli < Formula
  desc "Terminal user interface music player for YouTube Music"
  homepage "https://involvex.github.io/youtube-music-cli/"
  url "https://github.com/involvex/youtube-music-cli/archive/refs/tags/v0.0.98.tar.gz"
  sha256 "582bbea49931811d7cb1cd7562d4ecf1dac7b46f3f1f1b42080bebe868092866"
  license "MIT"
  head "https://github.com/involvex/youtube-music-cli.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1ca005767e26aa70d069dc685e15b72a10c9ab411f1ae0591fc4b3f41c34d663"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "98fe3a6aa10eee6e468aa97751f60fa50ae5af5a8da4e5578666c8cb50031122"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fcd0fddacd769f4c2222faa370ed502f296705ac86e85ddf9eed0904b12c739b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d88e0b57d2aa811ecb8a5bdba0b15851eedbad598df7e85f319ecfd4a7c256cf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "325c290ff09dce6fa0e008846c4aa447367e832b61bb5dadcad8abae7ee9b906"
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
