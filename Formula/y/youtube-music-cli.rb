class YoutubeMusicCli < Formula
  desc "Terminal user interface music player for YouTube Music"
  homepage "https://involvex.github.io/youtube-music-cli/"
  url "https://github.com/involvex/youtube-music-cli/archive/refs/tags/v0.0.86.tar.gz"
  sha256 "fd18653e3e25d84b7ba41412605dd64a58dbe5ca9edcbd76ef01ca4a3dedf6c1"
  license "MIT"
  head "https://github.com/involvex/youtube-music-cli.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3eb29f4eff3a8763010cf21de9e894100e1775c9c0e77ba94e6256fa75e6742d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6ceec8ae2b7220ab0c8466396b0ad4f075004735c87acb6420d5ab137d002aef"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "729db12d23e9b07ad1dc5d7a5b9ce7e6475e0f7ceaa6b2314caf30c204e85c65"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "872e9b240eb480acbcc13a38a291ceff3610501fd7be202a487f4fbe4d810c54"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0c7fa931de795da1afd4660bbd6231cdced666010762846227333406453f6454"
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
