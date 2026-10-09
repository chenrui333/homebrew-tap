class Splitrail < Formula
  desc "Real-time token usage tracker and cost monitor for CLI coding agents"
  homepage "https://splitrail.dev/"
  url "https://github.com/Piebald-AI/splitrail/archive/refs/tags/v3.11.1.tar.gz"
  sha256 "4b375ed0d042a96dd9d2f7802d924cee6fd6f368fbb2399bb93d0c4584d694a9"
  license "MIT"
  head "https://github.com/Piebald-AI/splitrail.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "aa672c9c485acdb1819e635d5c132086e964bc59c9985c6540dd40bd154aff12"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "560e4da7f6c80bfdbfae4ab4e0c32a417150a12e706dbeaf8a1dbf61884e5db1"
    sha256 cellar: :any,                 arm64_linux:   "ba4c569b12a53a6e17d42083fdca374aa80d15998d9e4664b03531367d815f4e"
    sha256 cellar: :any,                 x86_64_linux:  "434832924ae8469ef8e083121533ae519b18ce166b8cc003fc9f6754efc89d3f"
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
    assert_match version.to_s, shell_output("#{bin}/splitrail --version")

    output = shell_output("#{bin}/splitrail config init")
    assert_match "Created default configuration file", output
    assert_match "[server]", (testpath/".splitrail.toml").read
  end
end
