class InspectCertChain < Formula
  desc "Inspect and debug TLS certificate chains (without OpenSSL)"
  homepage "https://github.com/robjtede/inspect-cert-chain"
  url "https://github.com/robjtede/inspect-cert-chain/archive/refs/tags/v0.0.26.tar.gz"
  sha256 "09f7e0bbf5e2beec5259f3e039a56003ce9bba55a9a08ffd079ab171299bbf70"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/robjtede/inspect-cert-chain.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "39974b62cf7c2f5bf170626e8af24d5b4d536449b8a744416b3285dfcf4c2b7e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0b48d9a76d8c506c8037b16a7d3a3e8175f3ab3c39bb52e9fa4a21a5576d4c07"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d8e13b02f0cfd0a73c66bdb9d25e56fbc1500c89e461b30ae9a4c7d9e68c9c2a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fe4afeb97ae9e78389e54f9c2b99e35bfe8cf1b9a25e8aeb670f2c0dcc844363"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b352ed3edff7081f419da0fbd6c89e161e42a2754a7fdddf1f6be47b92101317"
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
