class YoutubeMusicCli < Formula
  desc "Terminal user interface music player for YouTube Music"
  homepage "https://involvex.github.io/youtube-music-cli/"
  url "https://github.com/involvex/youtube-music-cli/archive/refs/tags/v0.1.1.tar.gz"
  sha256 "77cbfe7baedbc9297f9d538fe18f1bcd71c4a35fa2ef9324b3d9113baae3b19d"
  license "MIT"
  head "https://github.com/involvex/youtube-music-cli.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2be3ea98bd3b8b1471fa372374aa9ca3d1751fc85001bbbd70d5a82e996cfd0a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8de0e5ff82be674106584f881c1a5b462ac16f57f8941a5473328b8c8360265e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "92a6e567090f5f0c0b07276107e564720700f35e4335c9fd0d36aed77f2b7ddd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d05bbca3a24dfdf051e4993368c5ff14a84dde2220958e8e119132aa271ca850"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "221cf2ac673e8fdba17bf8b814e6eeb3cf20670bf1e8b1eaeb3bb28fe32df5e8"
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
