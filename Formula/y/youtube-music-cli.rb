class YoutubeMusicCli < Formula
  desc "Terminal user interface music player for YouTube Music"
  homepage "https://involvex.github.io/youtube-music-cli/"
  url "https://github.com/involvex/youtube-music-cli/archive/refs/tags/v0.0.97.tar.gz"
  sha256 "7b1cbc06d3b5bc58ed219568a6f4eb310ed70808b28a0494781cd656d3437d7d"
  license "MIT"
  head "https://github.com/involvex/youtube-music-cli.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d0db82aa4f055f6b8f04cabc640eabf44b906a292162e8e3803cd0fe42ae1485"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "441d70feb27df6bfbb47395e789d7293022b42d87923a7616e29cb9ec9f145df"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "45b91d7269da226be4174470aac20a70e7226734ff127dc6bb38266e9eb548af"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6f2ce3930d4ff9dcf66f45b3501b48f4bcc405d8c3d2326f7f8b44c4a7793240"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d1d74c30d91f673a64e2554f498098cffc36af837a8b322143635da3387ea28f"
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
