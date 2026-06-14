class YtX < Formula
  desc "Browse YouTube from the terminal"
  homepage "https://github.com/Benexl/yt-x"
  url "https://github.com/Benexl/yt-x/archive/refs/tags/v0.8.6.tar.gz"
  sha256 "292f4eca4d8f321cb9f98c1999cc9f154dee61d7cc7fd8aa6b11c38a0505e75c"
  license "MIT"
  head "https://github.com/Benexl/yt-x.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "f634bcb18511c6b5ebd893fa6d616af7ae79dd77adf7b710adab850c119a2f64"
  end

  depends_on "ffmpeg"
  depends_on "fzf"
  depends_on "jq"
  depends_on "mpv"
  depends_on "yt-dlp"

  def install
    inreplace "yt-x", /^readonly CLI_VERSION=.*/, %Q(readonly CLI_VERSION="#{version}")

    inreplace "yt-x",
              'CLI_EXTENSIONS_DIR="$CLI_CONFIG_DIR/extensions"',
              <<~EOS.chomp
                CLI_EXTENSIONS_DIR="$CLI_CONFIG_DIR/extensions"
                CLI_BUNDLED_EXTENSIONS_DIR="#{pkgshare}/extensions"
              EOS

    inreplace "yt-x",
              '[ -s "$CLI_EXTENSIONS_DIR/$ext" ] && . "$CLI_EXTENSIONS_DIR/$ext"',
              <<~EOS.chomp
                if [ -s "$CLI_EXTENSIONS_DIR/$ext" ]; then
                  . "$CLI_EXTENSIONS_DIR/$ext"
                elif [ -s "$CLI_BUNDLED_EXTENSIONS_DIR/$ext" ]; then
                  . "$CLI_BUNDLED_EXTENSIONS_DIR/$ext"
                fi
              EOS

    inreplace "yt-x",
              'ext_dir="$HOME/.config/$CLI_NAME/extensions"',
              "ext_dir=\"#{pkgshare}/extensions\""

    libexec.install "yt-x"
    pkgshare.install "extensions"

    path = [
      Formula["ffmpeg"].opt_bin,
      Formula["fzf"].opt_bin,
      Formula["jq"].opt_bin,
      Formula["mpv"].opt_bin,
      Formula["yt-dlp"].opt_bin,
      "${PATH}",
    ].join(":")
    (bin/"yt-x").write_env_script(libexec/"yt-x", PATH: path)
  end

  test do
    version_output = shell_output("#{bin}/yt-x --version")
    assert_match "yt-x v#{version}", version_output

    require "open3"

    output, status = Open3.capture2e(bin/"yt-x", "--not-a-real-option")
    refute_predicate status, :success?
    assert_match "Usage: yt-x", output
  end
end
