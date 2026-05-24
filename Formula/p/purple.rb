class Purple < Formula
  desc "Terminal SSH config manager and cockpit for your servers"
  homepage "https://github.com/erickochen/purple"
  url "https://github.com/erickochen/purple/archive/refs/tags/v3.18.0.tar.gz"
  sha256 "be0335bd2b88234ddb27d49a03d61c87ca5f0089e0de2f4a0c387129f0c05993"
  license "MIT"
  head "https://github.com/erickochen/purple.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b065e89013070cf3849437d571c419110d1ba4c3e4f61f112b0a18aea4ee6b3e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "57662e7bc35f38bbcaf56b58784081e3de7759e3938736de572ccd4e58e28275"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e5172987f5243dde4c13759346a79e31da59904baf0c58accb1291eea17cc9e2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "141d670c97865f013ade8302f0a4592cfc3fae59ddb7a5ce01b386b69b8ca66e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5a4b4a525f7b0e46ea462c1078528515b9828f18bea1f80cd29328f597af1bb5"
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
