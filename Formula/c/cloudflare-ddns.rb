class CloudflareDdns < Formula
  desc "Small, feature-rich, and robust Cloudflare DDNS updater"
  homepage "https://github.com/favonia/cloudflare-ddns"
  url "https://github.com/favonia/cloudflare-ddns/archive/refs/tags/v1.15.1.tar.gz"
  sha256 "8f2288e84257a445934e02500db2b778e17e41d0be059a38170ec8bfff6caa1d"
  license "Apache-2.0" => { with: "LLVM-exception" }
  revision 1
  head "https://github.com/favonia/cloudflare-ddns.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6e360723140c6af8ec6864b687cd239f7bd28d399466b33623a0adb4f0aeec6c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6e360723140c6af8ec6864b687cd239f7bd28d399466b33623a0adb4f0aeec6c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6e360723140c6af8ec6864b687cd239f7bd28d399466b33623a0adb4f0aeec6c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "834ad25a604f94971064ebf1394fbdb1ba86d19f3ab690e674354b77fdb87b2e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2b4a1b939fb34c0bae8b3cc41b0701c02f23663cc061ce36dbbe45921a666d90"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "0" if OS.linux? && Hardware::CPU.arm?

    system "go", "build", *std_go_args(ldflags: "-s -w -X main.Version=#{version}"), "./cmd/ddns"
  end

  test do
    ENV["CLOUDFLARE_API_TOKEN"] = "invalid_token_for_testing"
    ENV["DOMAINS"] = "example.org"
    ENV["UPDATE_CRON"] = "@once"

    output = shell_output(bin/"cloudflare-ddns")
    assert_match version.to_s, output
    assert_match "Failed to check the existence of a zone named example.org", output
  end
end
