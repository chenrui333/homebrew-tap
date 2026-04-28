class MdnsScanner < Formula
  desc "Scan networks for IPs and hostnames, including mDNS aliases"
  homepage "https://github.com/CramBL/mdns-scanner"
  url "https://github.com/CramBL/mdns-scanner/archive/refs/tags/v0.26.2.tar.gz"
  sha256 "857f844434331e49a3a67363a44b8f9864919e551da898a18a6c1b270ad4c699"
  license "MIT"
  head "https://github.com/CramBL/mdns-scanner.git", branch: "trunk"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7f4654c40e035c76ca8b7cc4d79ffc006cfbf860f33dd1e566d12e7f528c3b39"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b7fb8370db0cfc5f7f3288df83861cc48e5e5398a21f10b45ae964c70c6c3037"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "693febef6b35405d478bad6015651e80401f4f6419e385510f6fb7cabef12b67"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "90c2e6bd163a8c2b9a0c71feb78f0a7d2cd5456739e3aa9f3b677f9a5ff6e2ec"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d037f2046e389cf6be09111ce6e17fb885ed2722fc134cd32a5bfacff6dd44d8"
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
