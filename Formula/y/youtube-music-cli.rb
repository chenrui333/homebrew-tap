class YoutubeMusicCli < Formula
  desc "Terminal user interface music player for YouTube Music"
  homepage "https://involvex.github.io/youtube-music-cli/"
  url "https://github.com/involvex/youtube-music-cli/archive/refs/tags/v0.0.74.tar.gz"
  sha256 "0916fa075b23144981213bb9b3ad3d6b0293b8cf14edaea5958cf0df1e310bb6"
  license "MIT"
  head "https://github.com/involvex/youtube-music-cli.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b552c97db658fc4bedc75ef694547e301d0a5026141f5deb672d6e861b2c6887"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7688088014a4dcfdc31fdf336b162683ba5a76ab504488d2ad0d09c65296a05b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3487803714836c2b3215fcf468f187ef44c709b87f5c5345cc94e5602ac83327"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "dabeabb2f4a367335974b222c0678cfad4676f8de2a1cc9d5b552ffc2290653c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5700155fd1d9dd24df460cd7f57723b59b2532433eec36bad01de58818f91621"
  end

  depends_on "chenrui333/tap/bun"
  depends_on "mpv"
  depends_on "node"
  depends_on "yt-dlp"

  def install
    system "npm", "install", "--include=dev", "--legacy-peer-deps",
           *std_npm_args(prefix: false, ignore_scripts: false)
    system Formula["chenrui333/tap/bun"].opt_bin/"bun", "run", "build"
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
