class Purple < Formula
  desc "Terminal SSH config manager and cockpit for your servers"
  homepage "https://github.com/erickochen/purple"
  url "https://github.com/erickochen/purple/archive/refs/tags/v3.15.8.tar.gz"
  sha256 "2750e13a213b70f96355146a3de340bde749603219e44e2786f1cd25f9508ed6"
  license "MIT"
  head "https://github.com/erickochen/purple.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d4cac1ea52730f4b06f9217af1c0540e5b5377f01aa04503adc8d7cf19f7d22b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2699c24348011ceac113bbd03fa40c5b3d9b3e91f2eec3681d6262cd5e0c1298"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "130ec3b36a5e1b88b6be91f78f6801ed431189cc3bb1f5e36c531fb49414bdcb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "64fb5690ec5fe36150ddd5de1a9f2e07fd2dcec5aedb3c530331479fd94fc852"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d92796440399151f3013d30565e4df3ec9232f46651b85753a4f98130dbe7090"
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
