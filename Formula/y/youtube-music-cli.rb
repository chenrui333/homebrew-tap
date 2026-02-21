class YoutubeMusicCli < Formula
  desc "Terminal user interface music player for YouTube Music"
  homepage "https://involvex.github.io/youtube-music-cli/"
  url "https://github.com/involvex/youtube-music-cli/archive/refs/tags/v0.0.27.tar.gz"
  sha256 "642e53b8a26a56ce4b4dae3b52ef4590ff2b76f74c7717ee351444a702e5315b"
  license "MIT"
  head "https://github.com/involvex/youtube-music-cli.git", branch: "main"

  depends_on "bun" => :build
  depends_on "mpv"
  depends_on "node"
  depends_on "yt-dlp"

  def install
    system "bun", "install", "--frozen-lockfile"
    system "bun", "run", "build"

    libexec.install Dir["*"]
    rm_r Dir[libexec/"node_modules/.bun/node-notifier@*/vendor/mac.noindex/terminal-notifier.app"], force: true
    rm_r libexec/"node_modules/node-notifier/vendor/mac.noindex/terminal-notifier.app", force: true
    chmod 0755, libexec/"dist/source/cli.js"

    (bin/"youtube-music-cli").write <<~SH
      #!/bin/bash
      exec "#{Formula["node"].opt_bin}/node" "#{libexec}/dist/source/cli.js" "$@"
    SH
    bin.install_symlink "youtube-music-cli" => "ymc"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/youtube-music-cli --version")
    assert_match "No plugins installed.", shell_output("#{bin}/youtube-music-cli plugins list")
  end
end
