class YoutubeMusicCli < Formula
  desc "Terminal user interface music player for YouTube Music"
  homepage "https://involvex.github.io/youtube-music-cli/"
  url "https://github.com/involvex/youtube-music-cli/archive/refs/tags/v0.0.100.tar.gz"
  sha256 "8dfb76adecd3e80b0bd6094e25b762f7cb0b8b4586ac265aeb128613a50fe909"
  license "MIT"
  head "https://github.com/involvex/youtube-music-cli.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7170d8920c43bf7e7778a7dfc5bd3080347df21611131cd517224e0eee7ff91b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "45bc8bc29f69e6ff6de24c5ef9926430a3afc5814ff6c93ffa0354fe8752ed01"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b6a82d911d812664bad561994501877fd86718716f6c3af357d489413f9f1139"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "02424a59284317e7a543c7973edbf134a6ecf8031d6cd54f391610e9d84b33a1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9813f3bc76c285d5f96e81d252e932a5b025091c2dda718803c6cb953b379f51"
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
