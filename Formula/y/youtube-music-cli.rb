class YoutubeMusicCli < Formula
  desc "Terminal user interface music player for YouTube Music"
  homepage "https://involvex.github.io/youtube-music-cli/"
  url "https://github.com/involvex/youtube-music-cli/archive/refs/tags/v0.1.2.tar.gz"
  sha256 "334370fb7ef4eaa9cf300c390b71309cc8f85d87785f6333971382cf148f4465"
  license "MIT"
  head "https://github.com/involvex/youtube-music-cli.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "12c3710e337f6213c9a62479c91cb993fd1ac7a7f2627f168b98b36df5ef376b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "782430cee63ba11e7e960ccb9afb308b01ac54ea8695c04f378abbf60c0eb631"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fb7381ce2b7b2db3788a33c572547ed6d5b75e5342056d2a49a37f8f7c1fc7d7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "da1c51d469c2daa099b99031189506d712abe4480fa1320c1a5ace0ea471a78c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f083562ea138229e787ce52e69bedc50fc98e25858e9765197dfa203d653fe1f"
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
