class YoutubeMusicCli < Formula
  desc "Terminal user interface music player for YouTube Music"
  homepage "https://involvex.github.io/youtube-music-cli/"
  url "https://github.com/involvex/youtube-music-cli/archive/refs/tags/v0.2.1.tar.gz"
  sha256 "d1b80b6acbc566f46eb0285b5d3aed3d1707e6ec879bf42789b3d518c644974a"
  license "MIT"
  head "https://github.com/involvex/youtube-music-cli.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "27be777250f1294a903f88b41d2edd05b3bae7f0f4f9660780f1ff40420ec26d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "129ef5ae92faa030d122f2c36d24f20bc9a782df5eaaa3a05df91490c887ea39"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0bf4cdea7de9b856b91d7a0eb05be0123f241aab2a34e6237d9e41d582f603bc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8f4f181553d9924865b68fafa1e7dfce00f1873a4c61e8f605b28a00065f1d92"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "43151548e255fe4acf87fc0309b051bdc722334c952766e7f01961ff9b5ca2b8"
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
