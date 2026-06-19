class Splitrail < Formula
  desc "Real-time token usage tracker and cost monitor for CLI coding agents"
  homepage "https://splitrail.dev/"
  url "https://github.com/Piebald-AI/splitrail/archive/refs/tags/v3.5.7.tar.gz"
  sha256 "2bc33866fa53eea70e647aff200b71e7f07f8bba5c679c14a1749e3dc6a4d882"
  license "MIT"
  head "https://github.com/Piebald-AI/splitrail.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "19929899b5603871c977bb95d1e05e22bf504906906c4c9c392c580f5fe5e90a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "724206d9ee6d99a78378f86f5cc2c1fda9ae1f2d64d6d6c6d7a0983cff797c89"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a000bacd37e3350720768ed26874ad69951326cefb05ca21f9f05a46236cd511"
    sha256 cellar: :any,                 arm64_linux:   "12a40b10e05cad082af35309e862d84c6fea843f164b212a261c0f28a719b1cc"
    sha256 cellar: :any,                 x86_64_linux:  "9306b919da1a1142cb0f93787bc22024b3a47be6c9e9f259a4073dc7022580ce"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/splitrail --version")

    output = shell_output("#{bin}/splitrail config init")
    assert_match "Created default configuration file", output
    assert_match "[server]", (testpath/".splitrail.toml").read
  end
end
