class Mnemo < Formula
  desc "Local-first AI memory layer with knowledge graph and semantic retrieval"
  homepage "https://github.com/zaydmulani09/mnemo"
  url "https://github.com/zaydmulani09/mnemo/archive/refs/tags/v0.1.0.tar.gz"
  sha256 "840dabaf752b5b5ebd385bb353d6eb521581d7ac7963c9bfc43601a89e4b2248"
  license "MIT"
  head "https://github.com/zaydmulani09/mnemo.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b8414f4a9041419761a4b129ca1e42eb448e6ce2c156d48a857b4d0e67852c48"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1b44ce82e196f9c4eea8962bb3bbb7b9610a9d118dbaf77ec2101ad55416be6f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9caffd7aa0625c9f77d0a89c1cdf1f6a63616f4586ba6b14362cef696b2ff57a"
    sha256 cellar: :any,                 arm64_linux:   "e36a40a168a54f0c3a3adb75025cdf9e04379dee7549e70858896d8cb5b49c72"
    sha256 cellar: :any,                 x86_64_linux:  "101628ff6ed713e15287059d13faf004fd05208eb329bbe7330b3292cbece226"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "openssl@3"

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/mnemo-cli")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mnemo-cli --version")
    output = shell_output("#{bin}/mnemo-cli --not-a-real-option 2>&1", 2)
    assert_match "not-a-real-option", output
  end
end
