class YoutubeMusicCli < Formula
  desc "Terminal user interface music player for YouTube Music"
  homepage "https://involvex.github.io/youtube-music-cli/"
  url "https://github.com/involvex/youtube-music-cli/archive/refs/tags/v0.0.36.tar.gz"
  sha256 "d8392f3f4251e1d333b4e10d409b335d233d787a0a61924f3fa6f34b97f4e6e7"
  license "MIT"
  head "https://github.com/involvex/youtube-music-cli.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "88c3a718f6d87c13f347796d4967f9f7296f95a571468afd8b064f8308cb977e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "52ce736036b1850812031a3567f025fd6c9e3572409eb3c96f621a2bdd0280a3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5513a6f05a620bf6e8eb2f51071f262d85ffe3324a597e21e59e6dc568dfaa43"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "740ff4cb90e7a104729aa94c2296511da9be0b687555216366f9be8e9bcd9863"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e633b9b6b5ce3b922ae35f89c381f2177b0ce5396277cc6211b4153d07bdba01"
  end

  depends_on "mpv"
  depends_on "node"
  depends_on "yt-dlp"

  def install
    system "npm", "install", "--include=dev", "--legacy-peer-deps",
           *std_npm_args(prefix: false, ignore_scripts: false)
    system "npm", "exec", "--", "tsc"
    system "npm", "install", *std_npm_args

    notifier_app = "lib/node_modules/@involvex/youtube-music-cli/node_modules/" \
                   "node-notifier/vendor/mac.noindex/terminal-notifier.app"
    rm_r libexec/notifier_app, force: true
    bin.install_symlink libexec/"bin/youtube-music-cli"
    bin.install_symlink libexec/"bin/ymc"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/youtube-music-cli --version")
    assert_match "No plugins installed.", shell_output("#{bin}/youtube-music-cli plugins list")
  end
end
