class InspectCertChain < Formula
  desc "Inspect and debug TLS certificate chains (without OpenSSL)"
  homepage "https://github.com/robjtede/inspect-cert-chain"
  url "https://github.com/robjtede/inspect-cert-chain/archive/refs/tags/v0.0.35.tar.gz"
  sha256 "e3c5f959c696bac691a3eff4b383eda2a9a821de74c535211a52acf81fd2c44b"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/robjtede/inspect-cert-chain.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "18df6d1199cf51dba0806d78749d4da7591195bbbcc15472cfe5dd89a62051b2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ebecaf372ba42fbff41b5b92d854ffaa99ed60b789b62cab24ee9d813cb4d9c1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8a219b94a119dcc17cdb8177069920481890baeaaba58bda61f54e0caea7d1bc"
    sha256 cellar: :any,                 arm64_linux:   "4b3287d84d83873233af3e7a862a8ec7ad6de7b647ed70abb9a1f6e7da3ed560"
    sha256 cellar: :any,                 x86_64_linux:  "82370b3480c9354be1376242659eeb7dbeb07a707bcd5da85d4d1ac52798b320"
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
