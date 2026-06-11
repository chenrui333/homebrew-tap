class YoutubeMusicCli < Formula
  desc "Terminal user interface music player for YouTube Music"
  homepage "https://involvex.github.io/youtube-music-cli/"
  url "https://github.com/involvex/youtube-music-cli/archive/refs/tags/v0.0.78.tar.gz"
  sha256 "5fb4c1303cf1d33322496d6c74d83eeb9822000795448e318de8f627c4ccb424"
  license "MIT"
  head "https://github.com/involvex/youtube-music-cli.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "801c436b937382256e1456206873e94ee6647de2eb84304e3026a34b42c39344"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bb06fcc6c0d34270c14eee3e890322c895d1ad4a8c5dd1372c3b4dbb0e4b670a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5bcf0c11febeffe8625a7a29bfa34ec1bfe407374c163838cc86d036a96bd550"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e704063d751d3ee2e894175d90360e68da84742659bb2817544450282ad989ed"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dd8ca6956f7c381174a2866b0846374f6b787ae25f08f68e4944115d29a073eb"
  end

  depends_on "chenrui333/tap/bun"
  depends_on "mpv"
  depends_on "node"
  depends_on "yt-dlp"

  def install
    system "npm", "install", "--include=dev", "--legacy-peer-deps",
           *std_npm_args(prefix: false, ignore_scripts: false)
    system Formula["chenrui333/tap/bun"].opt_bin/"bun", "run", "build"
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
