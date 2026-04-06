class Oyo < Formula
  desc "Step-through diff viewer"
  homepage "https://github.com/ahkohd/oyo"
  url "https://github.com/ahkohd/oyo/archive/refs/tags/v0.1.30.tar.gz"
  sha256 "9454a46fb1b7189151c3d264df88e6b0569df965f560d47dadc931e861158c2f"
  license "MIT"
  head "https://github.com/ahkohd/oyo.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5bb3cc343b6eebdcedeb7408ea5bf7676e1fd8d746e45dfdffdfd95412e6a5ad"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "29530d8adb5f7349972fc58ff903568f1e80a709cc082567145a48e56a841c9c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "71992799ff4cb43fb2f0f7c8ade7ad100a9b52d69223e0ead900efdf242f420b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fcbe16434b26ded1eabc240a3bce3771d834cd0d7687e5efbedcb776d10ae142"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7f4a9d436cace4d37f063b300aff4fba546a43a9ab57fd97d7aead0578868fb6"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "oniguruma"

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/oyo")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/oy --version")
    assert_match "github", shell_output("#{bin}/oy themes")
  end
end
