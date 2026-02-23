class YoutubeMusicCli < Formula
  desc "Terminal user interface music player for YouTube Music"
  homepage "https://involvex.github.io/youtube-music-cli/"
  url "https://github.com/involvex/youtube-music-cli/archive/refs/tags/v0.0.43.tar.gz"
  sha256 "e43a8e08705ce00fa220948a234d2f3a49c18d92260887d3ea99afeaad74cbee"
  license "MIT"
  head "https://github.com/involvex/youtube-music-cli.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b2a81efda9ac46b5817dbbb18c725fa8a143562a91305b79c2b831ea0b274f25"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1960e1ffa0ee79ee36385457b2f3cfe529c7e1e23e6d0bde2193dbc7737099af"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5c465a35f438aaae2930cf300ea1ef14c7d561c10530f47cd59e98481dceb35b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f5f22ffe319371166ba9ef7ccd334902c9d0824185217daa3b33890a5f75c163"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "32ef5422bddb1ac4cc14058eb80b29fb07456b0343e05d14f5151430d9c113af"
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
