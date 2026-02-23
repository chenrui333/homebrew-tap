class YoutubeMusicCli < Formula
  desc "Terminal user interface music player for YouTube Music"
  homepage "https://involvex.github.io/youtube-music-cli/"
  url "https://github.com/involvex/youtube-music-cli/archive/refs/tags/v0.0.38.tar.gz"
  sha256 "485677181a8f851d3d3a745c8e6cb07f34b41a9da80f9f9323caac283dfe2d99"
  license "MIT"
  head "https://github.com/involvex/youtube-music-cli.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "50761c1697735300fd4f78adf8667ff508f3b92f0b33cc81323e3c137e82ea65"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d49369c2e55997666d02822d68f55fc200af2c6968d5433f0b5f778c81fa1326"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c3eb36f1d055f008a061f5531bb02374bc086f998a151a919986f797b636e82d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5162bf2555fc3acdfb53013591dcc439119952f03a0664efb566f59d4f9d5344"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "65712c923216410c9b3dbf97d4a53abd2ccdd530947299755325794c8d67969a"
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
