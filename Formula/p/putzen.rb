class Putzen < Formula
  desc "Clean build and dependency artifacts"
  homepage "https://github.com/sassman/putzen-rs"
  url "https://github.com/sassman/putzen-rs/archive/refs/tags/v3.3.3.tar.gz"
  sha256 "7c402d8e3f33e38ea58986639e55fa1f2968c98365456d087c92599540eb11ee"
  license "GPL-3.0-only"
  head "https://github.com/sassman/putzen-rs.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0e09bd413a62180e35dc8ebc95f1a8ef860bc72082695c1e342f7896f71ae12d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4e025644553314fc54d0bf158c15aba8051923379921dcc51bdf874d05b35823"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "aba66f7334fd7a3d76a85e2476bcbe1fb34610249ef538528ed09cbbf45fdfa1"
    sha256 cellar: :any,                 arm64_linux:   "5eec8345e75e1f7cb20fac2cd6ff2e67b2ad9eff255c7f1c3412dcd507d5a04f"
    sha256 cellar: :any,                 x86_64_linux:  "08d5147f4b1ee5ef1c902fe8189cd25d88c2b1542d0cc1e88f8fe4fc29c84761"
  end

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/putzen --version")
    (testpath/"node_modules/test").write("keep me")
    system bin/"putzen", "--dry-run", "--yes-to-all", testpath
    assert_path_exists testpath/"node_modules/test"
  end
end
