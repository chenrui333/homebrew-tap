class Splitrail < Formula
  desc "Real-time token usage tracker and cost monitor for CLI coding agents"
  homepage "https://splitrail.dev/"
  url "https://github.com/Piebald-AI/splitrail/archive/refs/tags/v3.8.0.tar.gz"
  sha256 "e292eee32ed93a5f102c4259fca073109142f41033b4263f51018bcf1e29eb10"
  license "MIT"
  head "https://github.com/Piebald-AI/splitrail.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b579607a37a4bd6902a788ff843630cbd7e5b2ac16b10cffb2c8ac31567d0f1a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f2187c207157df6ab70cfb199ca59f56e71bacd1fa1e7bcf754fd52012255d9a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ba710b65ebbde72c3ba515e964eb36254b0a8737cf4d93f1cb678e79d3cb09c6"
    sha256 cellar: :any,                 arm64_linux:   "71fc9f0430e7db27b47683c6afd6e5d3d656c7028bc7d2a969965302b0c73176"
    sha256 cellar: :any,                 x86_64_linux:  "83c76806500b27321252073de3bd3f0ab602e2c75a0c62b8b0b15941fdc8e24d"
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
