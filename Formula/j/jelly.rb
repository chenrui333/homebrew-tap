class Jelly < Formula
  desc "Explore and stream Jellyfin via CLI"
  homepage "https://github.com/AzureHound/jelly"
  url "https://github.com/AzureHound/jelly/archive/refs/tags/v3.5.0.tar.gz"
  sha256 "312e2ba5feec45ccf1b3b6aff89c58752271652ccc520965adf8181c752574f8"
  license "0BSD"
  head "https://github.com/AzureHound/jelly.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "0f60ccd9d2c8e1a59d97875742c1f9c2029eb16a42f8799ce1b4332b219c7a4c"
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
    inreplace "src/jelly",
              'DEFAULT_MEDIA_PLAYER=$([[ "$OSTYPE" == "darwin"* ]] && echo "iina" || echo "mpv")',
              'DEFAULT_MEDIA_PLAYER="mpv"'
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
