class Purple < Formula
  desc "Terminal SSH config manager and cockpit for your servers"
  homepage "https://github.com/erickochen/purple"
  url "https://github.com/erickochen/purple/archive/refs/tags/v3.15.18.tar.gz"
  sha256 "19cdb6458130ccc38137bbab0effa8bc08b94af0def03b456ab6dc96d10abc15"
  license "MIT"
  head "https://github.com/erickochen/purple.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6c286d0a5d24bf200f777cec621756cb655c524069edcc3d9fbbd8369c02810d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "baadaa7fac865ec8f5ef45c7f798a8ac42b56c997f85faeca2337ac76d9cae6f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1120de167442fc77e3b18c5049b664f6e7a8be80d9a81f5da2f409cf4489d8d2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c41ca15b18eeffcf263efc51a33add91f86b267e42de158f98a471d3294cc41d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "74ca323118344ebada11ec07b33c595b19754dbf80035d7bf86836516a5b378d"
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
