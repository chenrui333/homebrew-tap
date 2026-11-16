class YoutubeMusicCli < Formula
  desc "Terminal user interface music player for YouTube Music"
  homepage "https://involvex.github.io/youtube-music-cli/"
  url "https://github.com/involvex/youtube-music-cli/archive/refs/tags/v0.3.9.tar.gz"
  sha256 "b7fe90ce4b28ce94c57f25ba33e990bdddf759c3b9d62ef8dfacba9ea1b77a13"
  license "MIT"
  head "https://github.com/involvex/youtube-music-cli.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "24057ea68c8a62d5ebdeff5d1084e1a18c0159e88949771832e85e4d4ea6024d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "28edede81c11a5e818c8d815c378da2f2f65d11a55f410cf31f6bd1c7b48260b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9fec0d1679b7770d9c86b2d4ed28027ec8df2094afa3d06193f7d777a9cd5971"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f741c64e806ae613dbb550cc6eda89ad4e0f728e9a5537707d6d0f6ae4ca4837"
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
