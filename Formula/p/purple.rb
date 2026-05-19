class Purple < Formula
  desc "Terminal SSH config manager and cockpit for your servers"
  homepage "https://github.com/erickochen/purple"
  url "https://github.com/erickochen/purple/archive/refs/tags/v3.15.2.tar.gz"
  sha256 "17cba142a55622a9b41f1fdd0248262cb50dc4a057c1324b92dcde88f75d8a2c"
  license "MIT"
  head "https://github.com/erickochen/purple.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5fb138d4c1a2f8f16b0f38949276617edda80d9bebbf42ea2a7de15fdd7774f3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b7f78ab1b7cf471a59022656114f7fb91f644d9ff9bc0a237f2fbc506044db65"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "079f189baaa4108139070a44b3acbcf6bc2a34e510b04c297da34bdf57b64357"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3cce65818fe62d9d8a1c33ceb3934b1b5d6447d69d171cc3feca8e1f4b7c2908"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5881f5e7beca3d715cc044af860149f69b1d0fb2764d4740ebb7ca2f7baf5d6b"
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
