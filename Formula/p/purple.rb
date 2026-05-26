class Purple < Formula
  desc "Terminal SSH config manager and cockpit for your servers"
  homepage "https://github.com/erickochen/purple"
  url "https://github.com/erickochen/purple/archive/refs/tags/v3.18.3.tar.gz"
  sha256 "7212224a8849ec9c038ad893b8b0e48f4319783cd402cbbcf77c3cbe7f6296e1"
  license "MIT"
  head "https://github.com/erickochen/purple.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "efb1a103ba21215d9f7a34e4c8d9bc0aac91ea48c41b73230d85051b5ec8abd3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c3b644ed4725e63c5c089674658cd42f729fb30391a84c276cbe301130302d6e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cfff726fefaa57d92d46d76e98a27bf728cca412cb00c81b44781d5dbb53d972"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "616aa483c32811c8563a97aec1a47c5708351fd598766acfafea87d5994db080"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "87a3b5a55222c0bad2bec314dc066ebf21a41ec1a364de0b78f7644dff2b592e"
  end

  depends_on "rust" => :build
  depends_on "openssl@3"

  def install
    ENV["OPENSSL_DIR"] = Formula["openssl@3"].opt_prefix
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/purple --version 2>&1")
  end
end
