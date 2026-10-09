class Splitrail < Formula
  desc "Real-time token usage tracker and cost monitor for CLI coding agents"
  homepage "https://splitrail.dev/"
  url "https://github.com/Piebald-AI/splitrail/archive/refs/tags/v3.11.1.tar.gz"
  sha256 "4b375ed0d042a96dd9d2f7802d924cee6fd6f368fbb2399bb93d0c4584d694a9"
  license "MIT"
  head "https://github.com/Piebald-AI/splitrail.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "47c27f2450df10872df25890028be45b7434278d6a0d9fb1d4ab2ce07df0d681"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "dc4ea81c9a41cf5789ab2c853c7a0fa50c5d831c37c12a12b130f856da0932ea"
    sha256 cellar: :any,                 arm64_linux:   "c76920be3f64a9db439bd74c027f8d8d0ec7fbbb2c336342f210e9d698b68a0b"
    sha256 cellar: :any,                 x86_64_linux:  "eb9c26989b8d67a13247e1bdccb40eb63e660380bcc282e506269748730bc540"
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
