class MdnsScanner < Formula
  desc "Scan networks for IPs and hostnames, including mDNS aliases"
  homepage "https://github.com/CramBL/mdns-scanner"
  url "https://github.com/CramBL/mdns-scanner/archive/refs/tags/v0.27.5.tar.gz"
  sha256 "349eb80afe2724c4f9d326f430f0a90fd8d48e64a2ab2ad846d601afda634b91"
  license "MIT"
  head "https://github.com/CramBL/mdns-scanner.git", branch: "trunk"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4e828cff871e97a064e76a0fbfc77041c0588b88e6818005223b466aca2358ab"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "87b8b7d0adff780b3cebc0edab7236acf2f2f5130bcf3faea9cddf781c633b9a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "716576d221119d4e54f334f31ab2c6ec467ea2b37e59c201cd1d31f24ec705d0"
    sha256 cellar: :any,                 arm64_linux:   "b55659e4ac1f2497c67b19466587ab293d6011799e44cb90c6bd2731f3fbacf2"
    sha256 cellar: :any,                 x86_64_linux:  "fede69596ab281e94762ca875d3a546d84e34cd05b463ab95e9ae6ccc0af1841"
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
