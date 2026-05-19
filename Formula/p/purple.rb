class Purple < Formula
  desc "Terminal SSH config manager and cockpit for your servers"
  homepage "https://github.com/erickochen/purple"
  url "https://github.com/erickochen/purple/archive/refs/tags/v3.15.0.tar.gz"
  sha256 "b8e2773dff2d0bb9341d9470a07206c36337de7592567d50078c86c177218d9c"
  license "MIT"
  head "https://github.com/erickochen/purple.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f7266ae05fcd425851dd71cd858d8302ad75a4bcd62c1b459a56c00f37f9d26b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a4fb3938d74a007c8149d73ec0a0cd29386481ef6d06972883f0900a65a9f544"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ac633eb971997ef5240f4cb6f35fe754cc5a856c45c01cb5dbc9f06f1cc91e99"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f6511be0e65a31c23586638188aeb673597c2f0c7c6719a1155ed2f53eb4a973"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f25c349b2094255f3701b9bf1792bd43eb9349f6c26d1282c3f1bd0274c651ba"
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
