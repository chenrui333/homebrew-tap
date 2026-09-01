class Prempti < Formula
  desc "Falco-powered policy and visibility layer for AI coding agents"
  homepage "https://github.com/falcosecurity/prempti"
  url "https://github.com/falcosecurity/prempti/archive/refs/tags/v0.3.0.tar.gz"
  sha256 "f32b7fb7a89087552cbc5b716ad72187ffccee39bfa9f0230ca3cc47af170067"
  license "Apache-2.0"
  head "https://github.com/falcosecurity/prempti.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5fece2e6aa582dbfac2589201f583bbd1ee531920da486b5597bdcc46cebb571"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5d7f254897b4a4d09d9a576b59c96db3dcdc189f277b6c87aa80b0a6fefbc914"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b63e77faad3717c6e197cd16ed073eb943b4a004c0ff3c5cea8da1e8a91cb16b"
    sha256 cellar: :any,                 arm64_linux:   "9ffefe256b2598561ecfd316a3bad91cfb49235969abf8b584692796165fc5b1"
    sha256 cellar: :any,                 x86_64_linux:  "4d9f339ffb8c502a30585c288f5b3a904c61696cdeea70836011ff5e42265524"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "tools/premptictl")
    system "cargo", "install", *std_cargo_args(path: "hooks/claude-code")
  end

  test do
    # FIXME: Upstream does not expose a version command; replace this with a version assertion when available.

    output = pipe_output("#{bin}/claude-interceptor", "{}\n")
    assert_match "permissionDecision", output
    assert_match "broker unavailable", output
  end
end
