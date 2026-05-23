class Purple < Formula
  desc "Terminal SSH config manager and cockpit for your servers"
  homepage "https://github.com/erickochen/purple"
  url "https://github.com/erickochen/purple/archive/refs/tags/v3.15.15.tar.gz"
  sha256 "36d9f0c0e4f7e49226724d67bf9c9c17038d7caffac0add6c98a31c37b3d5b06"
  license "MIT"
  head "https://github.com/erickochen/purple.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b5b66bc472a5809db11a858092596fcf2983c86c8cca1bbad95f8743f235eebe"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "95cf6d38f179f0b1ab0f29cf957a32c57e0fccb32cee46d1c1e184eacc09d63b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "39b120a8880e1284234a7aa06075298dda2c7954acbca55c3f33ba7d4e9525ec"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "12510f1cada5b1a171cd9fd307563a477a4a1036bfe04a8d250f03bdb390917f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "469371ea98e5edc2c6f8670b587d8b2a7a050435052aefbfecb92426d605b92a"
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
