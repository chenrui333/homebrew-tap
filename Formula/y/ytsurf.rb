class Ytsurf < Formula
  desc "YouTube in your terminal without the usual browser clutter"
  homepage "https://github.com/Stan-breaks/ytsurf"
  url "https://github.com/Stan-breaks/ytsurf/archive/refs/tags/v3.1.6.tar.gz"
  sha256 "458036a070733af43dc21f65439b34c17b745cafffce85a53cf5ee855dc00950"
  license "GPL-3.0-only"
  head "https://github.com/Stan-breaks/ytsurf.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, all: "1d13f735c272be4bd7127a5c8a6dac0a7e9ef293fd45e8ea2fc208460f521bed"
  end

  depends_on "bash"
  depends_on "chafa"
  depends_on "ffmpeg"
  depends_on "fzf"
  depends_on "jq"
  depends_on "mpv"
  depends_on "yt-dlp"

  def install
    inreplace "ytsurf.sh", "#!/usr/bin/env bash", "#!#{Formula["bash"].opt_bin}/bash"

    libexec.install "ytsurf.sh" => "ytsurf"

    path = [
      Formula["chafa"].opt_bin,
      Formula["ffmpeg"].opt_bin,
      Formula["fzf"].opt_bin,
      Formula["jq"].opt_bin,
      Formula["mpv"].opt_bin,
      Formula["yt-dlp"].opt_bin,
      "${PATH}",
    ].join(":")
    (bin/"ytsurf").write_env_script(libexec/"ytsurf", PATH: path)
  end

  test do
    require "open3"

    testbin = testpath/"test-bin"
    testbin.mkpath

    (testbin/"nvim").write <<~SH
      #!/bin/sh
      printf '%s\n' "$1" > "#{testpath}/editor-path"
      test -f "$1"
    SH
    chmod 0755, testbin/"nvim"

    env = {
      "HOME"            => testpath.to_s,
      "PATH"            => "#{testbin}:#{ENV.fetch("PATH")}",
      "XDG_CACHE_HOME"  => (testpath/"cache").to_s,
      "XDG_CONFIG_HOME" => (testpath/"config").to_s,
    }

    version_output, status = Open3.capture2e(env, bin/"ytsurf", "--version")
    assert_predicate status, :success?
    assert_match version.to_s, version_output

    output, status = Open3.capture2e(env, bin/"ytsurf", "--edit")
    assert_predicate status, :success?
    assert_equal "", output

    config_file = testpath/"config/ytsurf/config"
    assert_path_exists config_file
    assert_equal config_file.to_s, (testpath/"editor-path").read.strip
  end
end
