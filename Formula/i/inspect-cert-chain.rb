class InspectCertChain < Formula
  desc "Inspect and debug TLS certificate chains (without OpenSSL)"
  homepage "https://github.com/robjtede/inspect-cert-chain"
  url "https://github.com/robjtede/inspect-cert-chain/archive/refs/tags/v0.0.38.tar.gz"
  sha256 "6d7251d1073acc3fae2299af8da338654b85e5df40e1685fe23533f35dbb77ae"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/robjtede/inspect-cert-chain.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "079fda4d42c21b14c993044365731f98be0735550027dd90908efd03cd088a30"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4376f6c9415e7c53d4772aa899b3d0de8a0b00865ad15d919e479da7b32908e3"
    sha256 cellar: :any,                 arm64_linux:   "8826009ce96ece1b118e632e78ffaa916de43d00de99b58a0abd6c7ec972b6c3"
    sha256 cellar: :any,                 x86_64_linux:  "2d6963034908bf25625eb3ce9f24d7f818cc33be8029856bafa279a8a3dc055a"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    ENV["NO_COLOR"] = "1"

    assert_match version.to_s, shell_output("#{bin}/inspect-cert-chain --version")

    output = shell_output("#{bin}/inspect-cert-chain --host example.com")
    output = output.gsub(/\e\[[0-9;]*m/, "") # Remove ANSI color codes
    assert_match(/Subject: CN=(\*\.)?example\.com/, output)
  end
end
