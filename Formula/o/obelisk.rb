class Obelisk < Formula
  desc "Durable and deterministic workflow engine"
  homepage "https://github.com/obeli-sk/obelisk"
  url "https://github.com/obeli-sk/obelisk/archive/refs/tags/v0.39.4.tar.gz"
  sha256 "f8f332728a15fcaf28201570160642464e53dba3127041fabeca3ee4d9f97d3b"
  license "AGPL-3.0-only"
  head "https://github.com/obeli-sk/obelisk.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8f0c1a07d4fbabed6ace53b0fa80b96d334b68cf8db93b578cb0cca428c69e4a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8cf3edc250f8cf41fe8a1c91ed548ce050516b01256b1769e22d67eb1a17e812"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cb5b5a89fa2201acd24b303cdd27ee6d1b1332fbdcfeb92e8f20f753de2fa4c9"
    sha256 cellar: :any,                 arm64_linux:   "f31539b4346241b27812144efee4713ea356f3105c94232d714ea40f063ed507"
    sha256 cellar: :any,                 x86_64_linux:  "4ca53a1a799dcce34dd55273a2ebd087cce184176d9f8e962410d4b23ade8fc1"
  end

  depends_on "pkgconf" => :build
  depends_on "protobuf" => :build
  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/obelisk --version")
    output = shell_output("#{bin}/obelisk --not-a-real-option 2>&1", 2)
    assert_match "not-a-real-option", output
  end
end
