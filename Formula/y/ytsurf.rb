class Ytsurf < Formula
  desc "YouTube in your terminal without the usual browser clutter"
  homepage "https://github.com/Stan-breaks/ytsurf"
  url "https://github.com/Stan-breaks/ytsurf/archive/refs/tags/v3.1.7.tar.gz"
  sha256 "ba61e89fc6748c823030dec8406e4c2522aa2bb294db60a141e53b95e6bb0e22"
  license "GPL-3.0-only"
  head "https://github.com/Stan-breaks/ytsurf.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1300c07171a8252861ab7dc89290a2e18c709d1ad27a30c2a1abb6aa9f4919ae"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1300c07171a8252861ab7dc89290a2e18c709d1ad27a30c2a1abb6aa9f4919ae"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1300c07171a8252861ab7dc89290a2e18c709d1ad27a30c2a1abb6aa9f4919ae"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d5dadf3fb7e3dff92cf502dc7c9cad1a014bd4b9666fa347fdd59a74b2fb4544"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d5dadf3fb7e3dff92cf502dc7c9cad1a014bd4b9666fa347fdd59a74b2fb4544"
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

    cache_dir = testpath/".cache/ytsurf"
    cache_dir.mkpath
    (cache_dir/"queue.json").write "[]\n"

    output, status = Open3.capture2e(env, bin/"ytsurf", "--edit")
    assert_predicate status, :success?
    assert_equal "", output

    config_file = testpath/"config/ytsurf/config"
    assert_path_exists config_file
    assert_equal config_file.to_s, (testpath/"editor-path").read.strip
  end
end
