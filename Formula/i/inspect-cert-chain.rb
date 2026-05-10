class InspectCertChain < Formula
  desc "Inspect and debug TLS certificate chains (without OpenSSL)"
  homepage "https://github.com/robjtede/inspect-cert-chain"
  url "https://github.com/robjtede/inspect-cert-chain/archive/refs/tags/v0.0.25.tar.gz"
  sha256 "a764604a83c1118436ee43b8c5cbf423779d571c7610c529cb0c879c6570a9cb"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/robjtede/inspect-cert-chain.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5a2cfee43d513533c9338137741e16e1c605d8aca92b60a824553f63dd34c18c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7ccf6e848bbfca5a2cdbae58aa4218fdf7d3835c0f01a1e389e6fc5812769f92"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9889f3841d06a11adc4ef918d7ef852d57064ba5c6df9e82db0d981e9a8de72c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "43266973de3b7d18d6e090983346e4e6000fcbaf781868cf522ce5370f4c4ea8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c44a5b555c136b681573b6adde6e49593d720fefa54828c316bb734ddafc86cc"
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
