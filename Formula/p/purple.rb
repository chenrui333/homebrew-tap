class Purple < Formula
  desc "Terminal SSH config manager and cockpit for your servers"
  homepage "https://github.com/erickochen/purple"
  url "https://github.com/erickochen/purple/archive/refs/tags/v3.18.5.tar.gz"
  sha256 "119ec904623f33c2b928a249cd5feca32b017f92365d4f3f793dbaf61fb0465c"
  license "MIT"
  head "https://github.com/erickochen/purple.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "29e172d3b132cd12a4c4bfe04d0da17944df86a47a06c070eca33a183fdfe1de"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "80a50374f29c6bbd0a6ab315c9849d4ce4a4ca5cfbcc883571cb1bbbd6b69606"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6ae3342087e04668d480935a81d08f14b05a349dcb92b479fa16e29d44bb4b7e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d1d93ad731fde6a2cc526485bed49413325e0ba752bc844d5e74af976a110a8f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d75d76e37041392c7a092ce5e1e025a0f9e323a1f1ad01a17034e440eeae02a8"
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
