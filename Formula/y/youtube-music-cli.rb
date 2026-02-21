class YoutubeMusicCli < Formula
  desc "Terminal user interface music player for YouTube Music"
  homepage "https://involvex.github.io/youtube-music-cli/"
  url "https://github.com/involvex/youtube-music-cli/archive/refs/tags/v0.0.27.tar.gz"
  sha256 "642e53b8a26a56ce4b4dae3b52ef4590ff2b76f74c7717ee351444a702e5315b"
  license "MIT"
  head "https://github.com/involvex/youtube-music-cli.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "345e0ac8d17088e7f91f094ea17aeee9f567a003323d7862a5ef6ec71f00ee9d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3de0cfbcdc107576ad9465a3aed056adfe2376314a052d518df70d899b498d04"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1898924f697f9edd7cfd1cd799b23e1c204345abac569f86055ffb4d51d2152e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3d35020790177ce20985593e0cf332053ae2472048fd24b9ba8348d64d5ececc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5bb99b8dd8d742f64b2dfd201fd6218c9e3c4d2ec66b4a8ec2f7aef8d7cdc09b"
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
