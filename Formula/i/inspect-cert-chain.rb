class InspectCertChain < Formula
  desc "Inspect and debug TLS certificate chains (without OpenSSL)"
  homepage "https://github.com/robjtede/inspect-cert-chain"
  url "https://github.com/robjtede/inspect-cert-chain/archive/refs/tags/v0.0.36.tar.gz"
  sha256 "915cde6d35c3d3fdada23a5dfa29ff1ee1699197b060fb0c0c06fc2449285be8"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/robjtede/inspect-cert-chain.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "35aeb59e82c804f40f2416bbee49df0f465f1db9a7ce45fcd7a149b1ca6db563"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "87cec0a59472470307d44d1e02afb123ed89fe2393a011fc3b3c0a3b606f72ec"
    sha256 cellar: :any,                 arm64_linux:   "e5858568227b8c761bf89961ac10a4d6ff78976a19c7ec2d7556635d9f239a74"
    sha256 cellar: :any,                 x86_64_linux:  "5e045977adb04fc58f15355c2da7c892154186a5463cea6ee8c25bd4672ec640"
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
