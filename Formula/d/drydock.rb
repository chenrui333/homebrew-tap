class Drydock < Formula
  desc "Dashboard for a fleet of Git repositories"
  homepage "https://github.com/yetidevworks/drydock"
  url "https://github.com/yetidevworks/drydock/archive/refs/tags/v1.2.1.tar.gz"
  sha256 "8ef6a10cffe9f5162869ffa957030e279f9c08525193168f686a25067354dd64"
  license "MIT"
  head "https://github.com/yetidevworks/drydock.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8d5f116d86781ee7247754c613e55cf3cda0119c7b61e2964b93e63c1bc07a77"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2982841e0b8529608b98adefca3b09303902bd9c963228517e03b736b293bd52"
    sha256 cellar: :any,                 arm64_linux:   "7af89c8c3984f358c5810682fbb236ccca1f6552e59a87c92de006aabbcd0be9"
    sha256 cellar: :any,                 x86_64_linux:  "38e62ca079ffd172842fe253e1b2988796a164fd6c8b1ea9ff86f59b1939958a"
  end

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/drydock")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/drydock --version")
    output = shell_output("#{bin}/drydock config show")
    assert_match 'roots = ["~/Projects"]', output
  end
end
