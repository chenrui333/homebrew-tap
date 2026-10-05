class YoutubeMusicCli < Formula
  desc "Terminal user interface music player for YouTube Music"
  homepage "https://involvex.github.io/youtube-music-cli/"
  url "https://github.com/involvex/youtube-music-cli/archive/refs/tags/v0.3.0.tar.gz"
  sha256 "b284199f8624e257ba40d9decf91928659abe4ff6d7659947befa128032f9662"
  license "MIT"
  head "https://github.com/involvex/youtube-music-cli.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "45d08a49342dbb5431c742e42749d8ed537e0525cb459d54d6085038d1708701"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "12cd3f6e232d1094c0ae4a42b4c3217f3496dea373cea71c2a4d69c2ca4098a3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bbaa75ab912dfa345afb3ba22540ef2bed32bcde369b14efcac06a1768f5ed8a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cbefef285f8ab84b0e0affe7832a202aa058bd26cdb106a77bf01634f3f281ea"
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
