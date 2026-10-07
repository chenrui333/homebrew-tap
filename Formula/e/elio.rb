class Elio < Formula
  desc "Terminal file manager with rich previews and inline images"
  homepage "https://elio-fm.github.io/docs/"
  url "https://github.com/elio-fm/elio/archive/refs/tags/v1.13.0.tar.gz"
  sha256 "8025df57d84f3aeadd8eadeae2b293f66ad43b8b683d787a55a6ec314adf0e19"
  license "MIT"
  head "https://github.com/elio-fm/elio.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2a95459652655acdf8421378a0682fb9e503f7547b55ff52791124e963d692cc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b75d1ff7499a0e907b147fef19919bbfb61c846dd87994fec49c306aa3dceb98"
    sha256 cellar: :any,                 arm64_linux:   "5c5a2aa50c16d5806bf1fb7587306989f1f2df734d8ec09a9d741aea46928222"
    sha256 cellar: :any,                 x86_64_linux:  "0ee1b2f84c4c1234f4e7ed03919bed7397602e554f78b82cab5c3fb40846de69"
  end

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", "--locked"
  end

  def install
    ENV["CARGO_NET_OFFLINE"] = "true"
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/elio --version")
    assert_match "elio() {", shell_output("#{bin}/elio shell init zsh")
  end
end
