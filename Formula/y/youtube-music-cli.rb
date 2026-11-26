class YoutubeMusicCli < Formula
  desc "Terminal user interface music player for YouTube Music"
  homepage "https://involvex.github.io/youtube-music-cli/"
  url "https://github.com/involvex/youtube-music-cli/archive/refs/tags/v0.3.13.tar.gz"
  sha256 "6c1429e96eb32ea79226ff46599d5e2340858f485b92a6db6d1f1ca632a259de"
  license "MIT"
  head "https://github.com/involvex/youtube-music-cli.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    manifest_sha256 "c69a54a69d5b3222dd830960815101a855667440affcca0476b453a74728e8a4"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8d92ccada63a5b233aa5c7d6c344a4ea1b0a5f2e196420189434c7299fb07f2f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1b677018be7b7b841969e4fcda1868003aa7b327ea6bc9ac46da20c8ad525150"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2c03d9a9a0f2d86544bf9ce8d41ce596f5e86016ed870ab5cf81d5add65f2f95"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "455c2672d88e629135c1d4c36d9b2bec1454d82de1a38b6402dd43305771273a"
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
