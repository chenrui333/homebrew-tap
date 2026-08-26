class YoutubeMusicCli < Formula
  desc "Terminal user interface music player for YouTube Music"
  homepage "https://involvex.github.io/youtube-music-cli/"
  url "https://github.com/involvex/youtube-music-cli/archive/refs/tags/v0.1.6.tar.gz"
  sha256 "e477e3164411ac626b911b6f9ac3f36e4466a11ff8edb91e1eaea8a0521513f4"
  license "MIT"
  head "https://github.com/involvex/youtube-music-cli.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7ceaa9e00d8b3f060c0f1d4054d5919de216ca89a94031c8a8b98b232202335a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "953833f7df43999dd3eb42403fdec90cbc2e03a239e1d050c31d738834415f22"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7615e913450d26b8674d48fef95ba32c2ca2076d7f56d47b3b67690bd120c9a8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cb49d2f566425472cca7ff4d3271d9b58c344d14d936a20dcabc019b7925b778"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9741cc4272a9414231778c194b805eae140b8682b3d49fc53822e8cb88486030"
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
