class MdnsScanner < Formula
  desc "Scan networks for IPs and hostnames, including mDNS aliases"
  homepage "https://github.com/CramBL/mdns-scanner"
  url "https://github.com/CramBL/mdns-scanner/archive/refs/tags/v0.25.2.tar.gz"
  sha256 "dfe0f859ff587636cd13ab8359d340f62eb0d6d74df76ec23dda28d27c4ecffc"
  license "MIT"
  head "https://github.com/CramBL/mdns-scanner.git", branch: "trunk"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "130f07a9e079924504abf6c70017df5559e2fdab7e7a5e348ffd31ab3a044486"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a6bc9bb91dcc01323a297439cf0da4c9381e6626f46728164b4c8d0844fb9a70"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f454661f9dff369a450af431b2a2881c7037adea729847e7ac43f20189b7166b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f89676ce6a545d197e205ecfab69d0d7f96d485af4f8c9d5c6560a1eaea76069"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8fc5259a90613c4606d6fe57dd9eafd6cb0d5329afc8ed94a9e3ae4794669237"
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
