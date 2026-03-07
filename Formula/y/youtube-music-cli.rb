class YoutubeMusicCli < Formula
  desc "Terminal user interface music player for YouTube Music"
  homepage "https://involvex.github.io/youtube-music-cli/"
  url "https://github.com/involvex/youtube-music-cli/archive/refs/tags/v0.0.47.tar.gz"
  sha256 "b000a61677361af3b7b8b155c5b1f104b07700792e6408306086aaf4402ae18d"
  license "MIT"
  head "https://github.com/involvex/youtube-music-cli.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "86e5808f4f7bd9d24d0100ef4e5d0ae2ed8907829369825e97e5eb1617b6aee7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "db6766fde500dfb36de37d7a9f83b3b4bdf02f30015d64c7b3ae68510b887372"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "84c693ea01ef4f1e5f432ebf81cae7eeba401a0c5371b0b9230eb9b8e5e861ae"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "82c0f7eb38a212ba9825d9800127a4a96e1a6b5505203881ab8f70702b6b9782"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "790b7c24f9df371af4808ba7c2fd5cd0f8bd5bd99b9e46920068488ccdc4e499"
  end

  depends_on "mpv"
  depends_on "node"
  depends_on "yt-dlp"

  def install
    system "npm", "install", "--include=dev", "--legacy-peer-deps",
           *std_npm_args(prefix: false, ignore_scripts: false)
    system "npm", "exec", "--", "tsc"
    system "npm", "install", *std_npm_args

    notifier_app = "lib/node_modules/@involvex/youtube-music-cli/node_modules/" \
                   "node-notifier/vendor/mac.noindex/terminal-notifier.app"
    rm_r libexec/notifier_app, force: true
    bin.install_symlink libexec/"bin/youtube-music-cli"
    bin.install_symlink libexec/"bin/ymc"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/youtube-music-cli --version")
    assert_match "No plugins installed.", shell_output("#{bin}/youtube-music-cli plugins list")
  end
end
