class Purple < Formula
  desc "Terminal SSH config manager and cockpit for your servers"
  homepage "https://github.com/erickochen/purple"
  url "https://github.com/erickochen/purple/archive/refs/tags/v3.15.4.tar.gz"
  sha256 "97c91b69e0fb00e3ecd27e508b20e4be247cba5d704022c2b08e23f0134778ad"
  license "MIT"
  head "https://github.com/erickochen/purple.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a95e09fff57e385cc3eeef44cabbe2f6346ae6fb1aef70a3b0683fd98f8164eb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "33f136d0a200d8b3574320479a01e62de17ee2356906daac21b779ba29804531"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "130b51d727b49cdf71e43f34c18abc1c873825679cfe926083ef6b87a8735ba9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7e12ba08785897b0b0398b9097e612dd3c6df87eee109bd383d065e587a63fe6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c52ccae7816c9095b6f8cc77c86f7d81a54177baa7cfd9908bf38178cee11984"
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
