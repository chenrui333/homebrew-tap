class YoutubeMusicCli < Formula
  desc "Terminal user interface music player for YouTube Music"
  homepage "https://involvex.github.io/youtube-music-cli/"
  url "https://github.com/involvex/youtube-music-cli/archive/refs/tags/v0.0.78.tar.gz"
  sha256 "5fb4c1303cf1d33322496d6c74d83eeb9822000795448e318de8f627c4ccb424"
  license "MIT"
  head "https://github.com/involvex/youtube-music-cli.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3dfdedba7e5d6922480c78800e3baceb7cdcd3f32b29cd0942309b791b18118f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e56e58ff51a807d80dc046896a3a5020a7ed6120b05bf99d2c9e74c149f6684d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "92b581f729e872551c34cac1d3badc1c8d00c646ed6006b79cab27dac2ee15ac"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "880dabda3290e56bd0b4adb77d82ab33d4d3dc9df19e434d5c721d95d94ac0e1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c7518d25b40fe3936bf55e8b93810544d0e84b3c9b712c6e41715a871310dc65"
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
