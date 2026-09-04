class YoutubeMusicCli < Formula
  desc "Terminal user interface music player for YouTube Music"
  homepage "https://involvex.github.io/youtube-music-cli/"
  url "https://github.com/involvex/youtube-music-cli/archive/refs/tags/v0.2.1.tar.gz"
  sha256 "d1b80b6acbc566f46eb0285b5d3aed3d1707e6ec879bf42789b3d518c644974a"
  license "MIT"
  head "https://github.com/involvex/youtube-music-cli.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ec799ac222832771d11a7a335312d0660c164d84bde433355f4b1bced0f5be8c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "25e105a5217c13a124fa852fa5904d7918a6c28e63ef249e04dbd9226950b83c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "22d065a82ecf2d3107301aab01317735dff51176f8868381400b3ef2e4d74284"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "21e4207a3c356ddf5edd3e0e5eab27fd8b7830a82e42957a62d801586dedbf79"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d09b33a415a4279f52dc0dacadc0667b22eb90613f82b72175acf096b66cfb0b"
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
