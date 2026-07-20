class InspectCertChain < Formula
  desc "Inspect and debug TLS certificate chains (without OpenSSL)"
  homepage "https://github.com/robjtede/inspect-cert-chain"
  url "https://github.com/robjtede/inspect-cert-chain/archive/refs/tags/v0.0.27.tar.gz"
  sha256 "bcee02b570e14223e0e2ba45fc93d89d2600545b7938533ed89e88eaaf9879e3"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/robjtede/inspect-cert-chain.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f824d83fd66c13e4c6b01287665c6d1f6b6581e57cdfacb3da8ec242043939b2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e0364f1e64ed662f028246f920f15f0070ab95d5f45033d292409ea59fd97f87"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1f1cf65bb643aaee571deb5ff0c34dcb9efdb481bb9b25c94a14792b5330b1e5"
    sha256 cellar: :any,                 arm64_linux:   "e60db1625b4813b95eb1d1e57ba9b03209b9a1f06f66e97bef505ce46b7f58e1"
    sha256 cellar: :any,                 x86_64_linux:  "51ebe8bbb5b7518318d6c0ab2a8baf791cc947b7672d3a4e9628f9991bc0a2e5"
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
