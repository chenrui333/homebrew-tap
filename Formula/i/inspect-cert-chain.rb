class InspectCertChain < Formula
  desc "Inspect and debug TLS certificate chains (without OpenSSL)"
  homepage "https://github.com/robjtede/inspect-cert-chain"
  url "https://github.com/robjtede/inspect-cert-chain/archive/refs/tags/v0.0.31.tar.gz"
  sha256 "7821e7a14e1034c0e2fd0649403c82fb838acb1fe825595c192b49f0db3951c4"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/robjtede/inspect-cert-chain.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fa4458cdffcf4416f72a68dee9882de26b88e2e2652a098625e8b9fea5f8991a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f7a34a4cb30a3dafadf5a543a74c9cdbe34a36870146308981a6ca123c0ab0e8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "660b4796c4039d718f7b711731bc691900f7b54b78b7aec0415a948a99f7d64a"
    sha256 cellar: :any,                 arm64_linux:   "ad9e60efb5f5b3f946631fc1f85efee0705d65459a147ba6321ea7798723d514"
    sha256 cellar: :any,                 x86_64_linux:  "455b9e9115f3e7df0a78220181e34548e9fcce3bdf2bad4c8b250f389130b81e"
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
