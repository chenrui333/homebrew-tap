class YoutubeMusicCli < Formula
  desc "Terminal user interface music player for YouTube Music"
  homepage "https://involvex.github.io/youtube-music-cli/"
  url "https://github.com/involvex/youtube-music-cli/archive/refs/tags/v0.1.4.tar.gz"
  sha256 "bdf3557d3e1823a303202fc74ce5d3226e6b26f446b1a68e7069d90e17e3509d"
  license "MIT"
  head "https://github.com/involvex/youtube-music-cli.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c6c9020713c8fae2287762a708ea358787c5fc85a56224b4fdc32887df416214"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4ddbec51cc6c8a51f04788854c465798fc76a2210e5949c87c1bcc5729694810"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d4a8013e4678ee3bb9d4ce05922aa878b3e94f8587e3e2304ad32ab091e1a5a1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ddbf2e83905096ecec81dc508ef7e9cdfddfb8befdd6e21dfb372e22cee26a3e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f49cb54ef14ed59741865672c929502217d3585172d2f98421dfd7419d8fa2ec"
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
