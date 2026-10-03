class InspectCertChain < Formula
  desc "Inspect and debug TLS certificate chains (without OpenSSL)"
  homepage "https://github.com/robjtede/inspect-cert-chain"
  url "https://github.com/robjtede/inspect-cert-chain/archive/refs/tags/v0.0.43.tar.gz"
  sha256 "971e344e5180b938641b2c7c18a36ff8aae30912ef23672334ee619590cdfa91"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/robjtede/inspect-cert-chain.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "edfbf4e05be91cfbe12eac5793b01a53d11c60fc40a9bd00b97f5e839d765ad8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1a9ad92a51b3a4ae5bca8013ff8acbedac50e00ffd56e8f36468bbe8e4edd58d"
    sha256 cellar: :any,                 arm64_linux:   "3320d63f5e3f2451fcf99cbe9e0eb96487a946ffe302945a7d6fdfe6300cfdb8"
    sha256 cellar: :any,                 x86_64_linux:  "7afcf0be9d02b4ee2c77428baa30d666ebd07193db88d50983905c26032b3bc3"
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
