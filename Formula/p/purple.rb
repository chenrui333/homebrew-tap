class Purple < Formula
  desc "Terminal SSH config manager and cockpit for your servers"
  homepage "https://github.com/erickochen/purple"
  url "https://github.com/erickochen/purple/archive/refs/tags/v3.21.0.tar.gz"
  sha256 "15415693f3dfc3646147fbed35fe43dedbdb56765d1cb312b2ee6b79abcf1a0b"
  license "MIT"
  head "https://github.com/erickochen/purple.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5ba3cd2dd046dc742529c0259a84d084e1e7ec2a075d7595520795e227ba56c8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2e961d13c7b69092915d1a032241b2be60d027a042ccf21ab6570fc852e08d0a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "842f9faf9654805d0fb015dcff81c9929fd81040ab20cb896d96b7eb0d519b45"
    sha256 cellar: :any,                 arm64_linux:   "a3eeb51fc90b611692c392ac63ed0f18673e68b3a8eac7214b58cfa973e88a3a"
    sha256 cellar: :any,                 x86_64_linux:  "8b42ecbd4529f1f5eb35d22db0d24994bd0da168b138e84fbef1c74cb2038989"
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
