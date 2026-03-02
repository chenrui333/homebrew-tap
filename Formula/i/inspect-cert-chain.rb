class InspectCertChain < Formula
  desc "Inspect and debug TLS certificate chains (without OpenSSL)"
  homepage "https://github.com/robjtede/inspect-cert-chain"
  url "https://github.com/robjtede/inspect-cert-chain/archive/refs/tags/v0.0.24.tar.gz"
  sha256 "4f87014a4631b6901d17ad983a8dff443e81473b32660aa5335f02313436f580"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/robjtede/inspect-cert-chain.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2a21e2f90ebeae11f0347e6f2765fa23e4e5be95d3800dcac6dde387b09460ec"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4ffbd402371b6c4bec499e4160a8309d06a8e2a48a1c8c50f2c15d36b2db004b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b6a55a355872445d435310970e8b509fde12ca8b03fa2deeb9710e13d8ad1d45"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "00b3ee5d2850564904dcbab61dad59e8d8bf4397fba326f8a8e1b6dbd0658eb8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "141198e7ca883236f202a58a0e268b0b21f0c53f45ed7116557cd2baf8e66ef5"
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
