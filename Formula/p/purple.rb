class Purple < Formula
  desc "Terminal SSH config manager and cockpit for your servers"
  homepage "https://github.com/erickochen/purple"
  url "https://github.com/erickochen/purple/archive/refs/tags/v3.15.13.tar.gz"
  sha256 "136b5b07fcea8ed6436bb5b0a4906504eebc1695a591743b8915adde2dc3281d"
  license "MIT"
  head "https://github.com/erickochen/purple.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b7d5265f97686303a7d69188e2628a307d77f58df734386ab22918624925205d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "30e8c3d739d24648278e2464607fc3f0ee1e346bf6361e149425325dcbf84d56"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2b759f116c0159d2fccb01e7ddf01db89bda4a9b4e6230a79daa6c84c95e4a0c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6d6650282ad782ccec0f8e06e1106db3b333cf8207d44ded33caade4e4a247ae"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a2f7cbce4a8026bbd654e63718f26774c4e56a0005ed9cba4331b311e4dfdcb9"
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
