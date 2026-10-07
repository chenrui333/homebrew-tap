class Yeetfile < Formula
  desc "Encrypted file sharing and vault service for web and CLI"
  homepage "https://github.com/benbusby/yeetfile"
  url "https://github.com/benbusby/yeetfile/archive/refs/tags/v0.2.0.tar.gz"
  sha256 "ab581b920bd7f52f00c5baed497f51cdaf5608c32340949587ee0769a6fa81ca"
  license "AGPL-3.0-only"
  head "https://github.com/benbusby/yeetfile.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1692046601c78f3924f872df967f86f777cf6d18653693b7d8cf48c84e391c1e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1692046601c78f3924f872df967f86f777cf6d18653693b7d8cf48c84e391c1e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1d59c08a56222e9669a03b061ee3e923268094e549a12b5d4f2201936275fe6d"
    sha256 cellar: :any,                 x86_64_linux:  "3bd2ba91c150d9ffd67417df7f23ae6eece4db8decec36af410b0da6f1491be2"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cli"
  end

  test do
    # Seed the server info and wordlist caches so startup skips fetching them from yeetfile.com.
    ENV["XDG_CONFIG_HOME"] = testpath/".config"
    config_dir = testpath/".config/yeetfile"
    config_dir.mkpath
    (config_dir/"yeetfile.com.json").write "{}"
    (config_dir/"long-wordlist.json").write "[]"
    (config_dir/"short-wordlist.json").write "[]"

    assert_match "Usage: yeetfile <command> [args]", shell_output("#{bin}/yeetfile help")
    assert_match "-- Invalid command 'not-a-command'", shell_output("#{bin}/yeetfile not-a-command 2>&1")
    assert_match "server: https://yeetfile.com", (config_dir/"config.yml").read
  end
end
