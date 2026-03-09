class YoutubeMusicCli < Formula
  desc "Terminal user interface music player for YouTube Music"
  homepage "https://involvex.github.io/youtube-music-cli/"
  url "https://github.com/involvex/youtube-music-cli/archive/refs/tags/v0.0.56.tar.gz"
  sha256 "37dd60b17b71c79f80b1c9c16bb0da51a475ac741d4c3ebfbf12f65b7df1a82b"
  license "MIT"
  head "https://github.com/involvex/youtube-music-cli.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a761ed282ebdc1a9b1f1c05a4aa5be4e261c8a10c221bb3adc0e3007ba0c1f5a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "08972c1b77f291b9d3c4b1f718ffa7545830789bad949c018e7bfd726ffc83b0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ceaad3c822c6362c58c2ac633b227353293b187b22069f9e2f59d7936079e3cf"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e11e6505c53110ae3af9b11396b06083f14ddfc0b6bbf4f21f457d9969903c49"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d9d0595e8d8ba3484d131754afbd113d8f403533554cf6b4f939d5c5cb6981bf"
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
