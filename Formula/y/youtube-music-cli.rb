class YoutubeMusicCli < Formula
  desc "Terminal user interface music player for YouTube Music"
  homepage "https://involvex.github.io/youtube-music-cli/"
  url "https://github.com/involvex/youtube-music-cli/archive/refs/tags/v0.0.99.tar.gz"
  sha256 "23d5695cc9624367467223dbc6cd204ecd64be6509c880058574a1c9d852b982"
  license "MIT"
  head "https://github.com/involvex/youtube-music-cli.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "13006e7e987566240e97a0f9968ae06fd57a4f5cd946ece068ccdd70c4c6a372"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "198b0b3fb40832683da9bf401271522d6120341704f6f824e09f0466830d4498"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4373f777a5e8ed5442f443c2b94a2c4c0ed0b0d7f4b0aac7360c15f21f07b8d8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c853d8b6b0d06812619ed899b291ef758f1e8d58e8bbffaf97ce0934704c386a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1faec2407c9e7a2939c41a4a6391e12ac6ad323d601046b1b01dc34c4800bf9c"
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
