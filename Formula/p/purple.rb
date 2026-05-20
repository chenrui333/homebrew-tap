class Purple < Formula
  desc "Terminal SSH config manager and cockpit for your servers"
  homepage "https://github.com/erickochen/purple"
  url "https://github.com/erickochen/purple/archive/refs/tags/v3.15.8.tar.gz"
  sha256 "2750e13a213b70f96355146a3de340bde749603219e44e2786f1cd25f9508ed6"
  license "MIT"
  head "https://github.com/erickochen/purple.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "49dccc21d49434244238fc4b117f86e6bdc4e95582fc772b1fa1ec7d4d929bb1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6f3e0b8488ec549283feef3e9cf29295bd6fef86dc923fa2047470ab415fc96a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "faf89514ac3a2dfaad2b0328ea6f07c6385c62cf650878538e787d9a5f78bbc2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e75e805eea7a75857c76cf0bceeec381330e648fc626eef7d4e4332995e3c307"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "323eb3ce6d590babd87acfb9717dd8c0a51678c0e4036e50dde833fdc3b950a1"
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
