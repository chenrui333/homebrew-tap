class YoutubeMusicCli < Formula
  desc "Terminal user interface music player for YouTube Music"
  homepage "https://involvex.github.io/youtube-music-cli/"
  url "https://github.com/involvex/youtube-music-cli/archive/refs/tags/v0.3.12.tar.gz"
  sha256 "424f2656be88199ef03f0b2a45e6971c485549001b70f815858b7c73530eb78d"
  license "MIT"
  head "https://github.com/involvex/youtube-music-cli.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    manifest_sha256 "c34327a865ac9bbe88663912a1d617370b33fcf842273b29b3e473a0b221a092"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2533205bf9a3f5d6b6fdf571609f7f8f45922f8864edf006d6063ad52198ad88"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8b3c67903804a3c35b0bb1c1d7aff3f9ff73764f4ee06001f72aa8c162b4a32a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "182d57f6034e04edbd4aa178c5c32a1ac79afa86f1cc6603ae924002100878da"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0db1876fed645d1796818df0c76b1d07a50a634574b71ee642cd8478ec6ed65d"
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
