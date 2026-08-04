class YoutubeMusicCli < Formula
  desc "Terminal user interface music player for YouTube Music"
  homepage "https://involvex.github.io/youtube-music-cli/"
  url "https://github.com/involvex/youtube-music-cli/archive/refs/tags/v0.1.3.tar.gz"
  sha256 "df159a7aa35e5f816f748bd227fef35291fa3df9140df520434e20e73ce596e1"
  license "MIT"
  head "https://github.com/involvex/youtube-music-cli.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e3b952b70ff70b2e6b70021ad2cc8ee07e69e81fbf65180f5505c08ee6531bcd"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "56e2cae25ce838d9b417d2ec2e6ac213891e1f6dc39882394f7cc8d273daa782"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7a4a3b5994e6f2b44b135d38856a12d4d20b96604ad1b5e2b227071675bce306"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b8e8bcf4975327f28bc04fc1795424bff5d7c55723c74a6afc2fa2f861ac8794"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ca11c35ed1520dd4fdeee4790a9a28baa144733845235d65b3246e154bee21f9"
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
