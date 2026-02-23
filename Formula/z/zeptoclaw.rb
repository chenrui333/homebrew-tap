class Zeptoclaw < Formula
  desc "Lightweight personal AI gateway with layered safety controls"
  homepage "https://zeptoclaw.com/"
  url "https://github.com/qhkm/zeptoclaw/archive/refs/tags/v0.5.1.tar.gz"
  sha256 "8ce2db1022cee8500ec8a7cf0257bfe22558d1421907397b4c4092bac732ae02"
  license "Apache-2.0"
  head "https://github.com/qhkm/zeptoclaw.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5a4319edf06107722dfcee9ecd3357d65d7114ca3c5a9befecb97fccb4298e1a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7ea565cb6992562ad66b0b267a881a7b2c9d2e46c32cdce96177d0282244ce8b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f5968ff939c3d5f42b0093d08e10634823b9d6e858cc2ce343b4af96299a33ed"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ac2914cb0fc641636badaafe7b70c90fddb25224d7c3253597f37546717d1ff8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0b8fd8b963a4d87a3c316dbdf7c192cf07364c0e0862ecc49a1ebb4c70adbd21"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  service do
    run [opt_bin/"zeptoclaw", "gateway"]
    keep_alive true
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/zeptoclaw --version")
    assert_match "No config file found", shell_output("#{bin}/zeptoclaw config check")
  end
end
