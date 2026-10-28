class YoutubeMusicCli < Formula
  desc "Terminal user interface music player for YouTube Music"
  homepage "https://involvex.github.io/youtube-music-cli/"
  url "https://github.com/involvex/youtube-music-cli/archive/refs/tags/v0.3.6.tar.gz"
  sha256 "f4b35f397d2d2b79d606cbccbc4043a15c8da1e5bdc7f149c38270dff9a54902"
  license "MIT"
  head "https://github.com/involvex/youtube-music-cli.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9d995ac5861e21821a506d4feb6b08f2497bcfebbe79ecd03597cf051a1594e3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "606ebc9e3988766a6f85070126d8f8a6bd33384b1631698d5f1d284480e4d487"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2bfbc77542267a4b77db367320c661e2112e1da14b8b67f53c5465f6d942b9cd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2d5eb27cc91aba368a3ef65029f36f4fe15e2ba779daae09b9f7538c18dafee0"
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
