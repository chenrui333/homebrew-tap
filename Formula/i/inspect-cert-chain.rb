class InspectCertChain < Formula
  desc "Inspect and debug TLS certificate chains (without OpenSSL)"
  homepage "https://github.com/robjtede/inspect-cert-chain"
  url "https://github.com/robjtede/inspect-cert-chain/archive/refs/tags/v0.0.23.tar.gz"
  sha256 "e6a516b0bb054d721fa357431c0c1016257ab3e9c277404b60d813eadcc77baa"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/robjtede/inspect-cert-chain.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "257d58ca38def6dce0537d92898b1c125c0a637c8e421b76190910b46047c2c6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b9d64ffe94fd33b8826b37daa022399830c4077087ba332ae18e834f3c626ba5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4371dd2910a2ff1db2088efd76ce44561407b5942dfba96107e516128e869a10"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "df6bdd1a70b26b0d8ddd30f0a217faf90dc03a283a1ec49638ecb14f4463c445"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9fc66f7f8c2bedf044e692b267abc28514912e08dc7b20f1e51d8e9d9218806a"
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
    assert_match "Subject: CN=*.example.com,O=Internet Corporation for Assigned Names and Numbers", output
  end
end
