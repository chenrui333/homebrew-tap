class Jelly < Formula
  desc "Explore and stream Jellyfin via CLI"
  homepage "https://github.com/AzureHound/jelly"
  url "https://github.com/AzureHound/jelly/archive/refs/tags/v3.5.1.tar.gz"
  sha256 "9ce9157fd534a3bf178cade16a984756ad26259f8d3628d74c36d9620cf1bb30"
  license "0BSD"
  head "https://github.com/AzureHound/jelly.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, all: "aa003d72a2b0176feb19cf28d4741f80253512d6ec99db101842b11386c9bb2f"
  end

  depends_on "bash"
  depends_on "chafa"
  depends_on "curl"
  depends_on "fzf"
  depends_on "jq"
  depends_on "mpv"
  depends_on "socat"

  deny_network_access!

  def install
    inreplace "src/jelly", "#!/usr/bin/env bash", "#!#{formula_opt_bin("bash")}/bash"
    # upstream v3.5.1 tag still hardcodes VERSION="3.5.0"
    inreplace "src/jelly", /^VERSION=".*"$/, "VERSION=\"#{version}\""
    bin.install "src/jelly" => "jelly"
  end

  test do
    assert_match "v#{version}", shell_output("#{bin}/jelly --version")

    config_dir = testpath/".config/jelly"
    cache_dir = testpath/".cache/jelly/covers"
    config_dir.mkpath
    cache_dir.mkpath

    (config_dir/"config").write <<~EOS
      server=http://example.invalid
      api_key=test-key
      editor=nano
      media_preview=false
      player=mpv
    EOS

    migrate_output = shell_output("#{bin}/jelly migrate config")
    assert_match "Migrating Config", migrate_output
    assert_equal "server=http://example.invalid\napi_key=test-key\n", (config_dir/"config").read

    (cache_dir/"thumb.jpg").write "cache"
    cache_output = shell_output("#{bin}/jelly rm cache")
    assert_match "Cache Wiped", cache_output
    refute_path_exists cache_dir/"thumb.jpg"
  end
end
