class YoutubeMusicCli < Formula
  desc "Terminal user interface music player for YouTube Music"
  homepage "https://involvex.github.io/youtube-music-cli/"
  url "https://github.com/involvex/youtube-music-cli/archive/refs/tags/v0.0.97.tar.gz"
  sha256 "7b1cbc06d3b5bc58ed219568a6f4eb310ed70808b28a0494781cd656d3437d7d"
  license "MIT"
  head "https://github.com/involvex/youtube-music-cli.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "06d12ee28f7c4dc4c22979e0878d7372a1b040d2128a89ea741e4ea8bd3b9076"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "83a2e7698ddf656afef82b6d855d7d27da5d349d43b837ea46813ec51917e209"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "69a9d2a96526a7046c2cec77b914e17e22a6efd41e01eecd878ed495b868ce97"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "aa2e5867f9d7c78abb81e75a42012d052428e1ab183a74b8c2c240ee52ab02d3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "765fcabcc8be901ca53500ea7be6b7dd5c111f8e2d09f8bfdad7377ec219ee25"
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
