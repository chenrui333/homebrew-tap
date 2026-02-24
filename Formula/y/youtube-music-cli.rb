class YoutubeMusicCli < Formula
  desc "Terminal user interface music player for YouTube Music"
  homepage "https://involvex.github.io/youtube-music-cli/"
  url "https://github.com/involvex/youtube-music-cli/archive/refs/tags/v0.0.46.tar.gz"
  sha256 "9dbf471e2ff0f1e84ed6a7f23aecee377f344b667c4334cf9dd921c91a53de7f"
  license "MIT"
  head "https://github.com/involvex/youtube-music-cli.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "87f6582000a89443d00f77f420e0aadd5f1000675b317ac86872d232615e8ca7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fadafcbd9d78776add03ca8ed33321d831361ebc46419ddaa96f354bff178024"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bf138f640d13729e6da65024214a401c7e302fc2fb476363a8c8ad1df5efd947"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "272f363b7b803da5a65c49b5d7d0d3e1e65e7f4d6344ab0b42a7e2ff247a15f4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "664bda5f5caf14229c7b5cb19a1ba4a125feb9de6e3c9fb7ad5e15de6b5f250c"
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
