class YtX < Formula
  desc "Browse YouTube from the terminal"
  homepage "https://github.com/Benexl/yt-x"
  url "https://github.com/Benexl/yt-x/archive/refs/tags/v0.8.0.tar.gz"
  sha256 "94eeae697b59fef6f3d327be3273041ac8c83f630779a5fa0def627eefb9e5dc"
  license "MIT"
  head "https://github.com/Benexl/yt-x.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, all: "9acabed0ff42e4b8ac2c63e93fef357fe0c93c3efe81949f9acfd0b5083374a7"
  end

  depends_on "ffmpeg"
  depends_on "fzf"
  depends_on "jq"
  depends_on "mpv"
  depends_on "yt-dlp"

  def install
    inreplace "yt-x", /^CLI_VERSION=.*/, %Q(CLI_VERSION="#{version}")

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
    require "open3"

    env = {
      "HOME"            => testpath.to_s,
      "XDG_CACHE_HOME"  => (testpath/"cache").to_s,
      "XDG_CONFIG_HOME" => (testpath/"config").to_s,
    }

    desktop_entry, status = Open3.capture2e(env, bin/"yt-x", "--generate-desktop-entry", stdin_data: "\n")
    assert_predicate status, :success?
    assert_match "[Desktop Entry]", desktop_entry
    assert_match "Name=yt-x", desktop_entry
    assert_match "Version=#{version}", desktop_entry

    version_output, status = Open3.capture2e(env, bin/"yt-x", "--version")
    assert_predicate status, :success?
    assert_match "yt-x v#{version}", version_output
  end
end
