class InspectCertChain < Formula
  desc "Inspect and debug TLS certificate chains (without OpenSSL)"
  homepage "https://github.com/robjtede/inspect-cert-chain"
  url "https://github.com/robjtede/inspect-cert-chain/archive/refs/tags/v0.0.43.tar.gz"
  sha256 "971e344e5180b938641b2c7c18a36ff8aae30912ef23672334ee619590cdfa91"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/robjtede/inspect-cert-chain.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e479f5fee6a2810eb9bf3ff9ea8fbec02e55fda2ecf32533cb63831ee35efcb5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "942b5485b499090d5f2864a79e9c722dabdc8fb3bb4ad4d62ea2b0a9195e0b08"
    sha256 cellar: :any,                 arm64_linux:   "480da1b7cf636dbdf139f229a890fb3bea43f1d3d133d81219660d7b891b25d9"
    sha256 cellar: :any,                 x86_64_linux:  "fdc75508a9e6035d64f2ac5eaeec3dc02989d56d9bb3605363abec7ee9dc93ba"
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
