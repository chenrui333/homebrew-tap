class YoutubeMusicCli < Formula
  desc "Terminal user interface music player for YouTube Music"
  homepage "https://involvex.github.io/youtube-music-cli/"
  url "https://github.com/involvex/youtube-music-cli/archive/refs/tags/v0.1.6.tar.gz"
  sha256 "e477e3164411ac626b911b6f9ac3f36e4466a11ff8edb91e1eaea8a0521513f4"
  license "MIT"
  head "https://github.com/involvex/youtube-music-cli.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d73de88565caba83cdcb3e8dabd9eba0641ae579f0682d0d3f43151bab8150ee"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "dfed22acdf274166ed368fdd2c82e7912be50c7506cadf11763e4ab9ccda7da8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e750c397d8ed4b5fa07f4683b1408a81f0a83242afb1029f14fa23278f3c1756"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "eef82ef595b5ca0a0c80fa2707d14dffecc3ddf24beca3e783e3ba47457b8fbd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3045ef9a933482e36cfd5b73469b8050c3fe46d2556937a8b3e710acee6fe7bc"
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
