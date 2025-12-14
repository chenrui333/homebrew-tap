class Flowrs < Formula
  desc "TUI application for Apache Airflow"
  homepage "https://github.com/jvanbuel/flowrs"
  url "https://github.com/jvanbuel/flowrs/archive/refs/tags/v0.5.1.tar.gz"
  sha256 "0a9891411bef567baea10df68a35cbd783b6e4d3da6853ca09a97ac044bb225a"
  license "MIT"
  head "https://github.com/jvanbuel/flowrs.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "73dcbe4641b52c3acca42d20d156c24b225cc65f5c37caa135c8b8ad533742f7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1686bc44c8351362b82d7eaccba05a83f39ade57a2b34cdbfca7b9d8e718a8fe"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "56ee156abf05f7cd92fa7d11f902269c1b1ed31919d0299af14adf196edb8c5a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a4a02daff0187e18a9508bfb62a98957b83ede4399b0b2099c65788f8444cc5a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bcd12d05d4c6966306f3da5e59b94b75c98e360c86cc2b17afe9aa50a2fb9309"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "openssl@3"
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/flowrs --version")
    assert_match "No servers found in the config file", shell_output("#{bin}/flowrs config list")
  end
end
