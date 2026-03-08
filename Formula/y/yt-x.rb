class YtX < Formula
  desc "Browse YouTube from the terminal"
  homepage "https://github.com/Benexl/yt-x"
  url "https://github.com/Benexl/yt-x/archive/refs/tags/v0.4.5.tar.gz"
  sha256 "60d181286a8489798a9a80df6f9b6a36660370f31029a70f56260a4eb0c373f5"
  license "MIT"
  head "https://github.com/Benexl/yt-x.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, all: "21857de520a03f64fb8fa48b5230626a9cbe4fbb06781cd9b073a1dcb6463c14"
  end

  depends_on "bash"
  depends_on "ffmpeg"
  depends_on "fzf"
  depends_on "jq"
  depends_on "mpv"
  depends_on "yt-dlp"

  def install
    inreplace "yt-x", "#!/usr/bin/env bash", "#!#{Formula["bash"].opt_bin}/bash"
    inreplace "yt-x", 'CLI_VERSION="0.4.0"', %Q(CLI_VERSION="#{version}")

    inreplace "yt-x",
              'CLI_EXTENSION_DIR="$CLI_CONFIG_DIR/extensions"',
              <<~EOS.chomp
                CLI_EXTENSION_DIR="$CLI_CONFIG_DIR/extensions"
                CLI_BUNDLED_EXTENSION_DIR="#{pkgshare}/extensions"
              EOS

    inreplace "yt-x",
              '[ -s "$CLI_EXTENSION_DIR/$ext" ] && . "$CLI_EXTENSION_DIR/$ext"',
              <<~EOS.chomp
                if [ -s "$CLI_EXTENSION_DIR/$ext" ]; then
                  . "$CLI_EXTENSION_DIR/$ext"
                elif [ -s "$CLI_BUNDLED_EXTENSION_DIR/$ext" ]; then
                  . "$CLI_BUNDLED_EXTENSION_DIR/$ext"
                fi
              EOS

    old_extension_dispatch = [
      "  -x | --extension)",
      "    [ -n \"$2\" ] || usage 1",
      "    . \"$CLI_EXTENSION_DIR/$2\"",
      "    shift",
      "    ;;",
      "",
    ].join("\n")
    new_extension_dispatch = [
      "  -x | --extension)",
      "    [ -n \"$2\" ] || usage 1",
      "    if [ \"${2#/}\" != \"$2\" ]; then",
      "      . \"$2\"",
      "    elif [ -s \"$CLI_EXTENSION_DIR/$2\" ]; then",
      "      . \"$CLI_EXTENSION_DIR/$2\"",
      "    elif [ -s \"$CLI_BUNDLED_EXTENSION_DIR/$2\" ]; then",
      "      . \"$CLI_BUNDLED_EXTENSION_DIR/$2\"",
      "    else",
      "      echo \"Extension '$2' not found in $CLI_EXTENSION_DIR or $CLI_BUNDLED_EXTENSION_DIR\" >&2",
      "      exit 1",
      "    fi",
      "    shift",
      "    ;;",
      "",
    ].join("\n")
    inreplace "yt-x", old_extension_dispatch, new_extension_dispatch

    inreplace "yt-x",
              '--arguments \"(command ls $CLI_EXTENSION_DIR)\"',
              '--arguments \"(command ls $CLI_BUNDLED_EXTENSION_DIR)\"'

    libexec.install "yt-x"
    pkgshare.install "extensions"

    ENV["HOME"] = buildpath.to_s
    generate_completions_from_executable(libexec/"yt-x", "completions", shell_parameter_format: :flag)

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

    desktop_entry, status = Open3.capture2e(env, bin/"yt-x", "-x", "example", "--generate-desktop-entry")
    assert_predicate status, :success?
    assert_match "[Desktop Entry]", desktop_entry
    assert_match "Name=yt-x", desktop_entry
    assert_match "version=#{version}", desktop_entry

    assert_path_exists testpath/".config/yt-x/yt-x.conf"
    assert_path_exists testpath/"Videos/yt-x"

    fish_completion, status = Open3.capture2e(env, bin/"yt-x", "completions", "--fish")
    assert_predicate status, :success?
    assert_match "complete -c yt-x", fish_completion

    version_output, status = Open3.capture2e(env, bin/"yt-x", "--version")
    assert_predicate status, :success?
    assert_match "yt-x v#{version}", version_output
  end
end
