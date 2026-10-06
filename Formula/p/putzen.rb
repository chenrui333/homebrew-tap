class Putzen < Formula
  desc "Clean build and dependency artifacts"
  homepage "https://github.com/sassman/putzen-rs"
  url "https://github.com/sassman/putzen-rs/archive/refs/tags/v3.3.3.tar.gz"
  sha256 "7c402d8e3f33e38ea58986639e55fa1f2968c98365456d087c92599540eb11ee"
  license "GPL-3.0-only"
  head "https://github.com/sassman/putzen-rs.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c6f8944f23b39d05f3ace041738e4c97ee5bcb10386eed020c33292053d2de08"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d36e59d74173689d954ce47408ded30a99dd7c4a2ca25c18df538a14dd6ec2e4"
    sha256 cellar: :any,                 arm64_linux:   "10f4b2d3f10ff69c5c39d3581e68e7efb58181915c1c1134fc04bcd63876aad2"
    sha256 cellar: :any,                 x86_64_linux:  "6109d00708ab7563480295431fba7dd91edb9725ad6b78f3ff16ee6faf8f576e"
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
