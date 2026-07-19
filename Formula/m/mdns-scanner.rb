class MdnsScanner < Formula
  desc "Scan networks for IPs and hostnames, including mDNS aliases"
  homepage "https://github.com/CramBL/mdns-scanner"
  url "https://github.com/CramBL/mdns-scanner/archive/refs/tags/v0.27.5.tar.gz"
  sha256 "349eb80afe2724c4f9d326f430f0a90fd8d48e64a2ab2ad846d601afda634b91"
  license "MIT"
  head "https://github.com/CramBL/mdns-scanner.git", branch: "trunk"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5b53f052f12ca7e2a0b4c931affc59e2383996e038f9416dae0d926bc52ed208"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3c254993a980403e25bea42aa604e2eb93a475c42de15f16a510f8c8acfaa961"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4e2d588cd6b8859a15caa255172a1cd4a609648b2274ace2e8d4709667af5d59"
    sha256 cellar: :any,                 arm64_linux:   "227ef9ee94043e99515322ac15f6c2f1dbf7e7ba81db45b6df1be3d4371ac244"
    sha256 cellar: :any,                 x86_64_linux:  "c25b2969f6c530710ba4436805d79da7dde55b9a471ed24c779c1b313a76f358"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mdns-scanner --version")
    assert_match "# mdns-scanner configuration file", shell_output("#{bin}/mdns-scanner dump-default-config")
  end
end
