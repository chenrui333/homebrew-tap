class CloudflareDdns < Formula
  desc "Small, feature-rich, and robust Cloudflare DDNS updater"
  homepage "https://github.com/favonia/cloudflare-ddns"
  url "https://github.com/favonia/cloudflare-ddns/archive/refs/tags/v1.18.0.tar.gz"
  sha256 "eeec730977050046bde90d4e11199d4d479f035a34a8300fdc94a4247a0c41e0"
  license "Apache-2.0" => { with: "LLVM-exception" }
  head "https://github.com/favonia/cloudflare-ddns.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "bf5c10cc9e245e946f7113791774f2881b3215d8827897acb7a1a326c03c7ea8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bf5c10cc9e245e946f7113791774f2881b3215d8827897acb7a1a326c03c7ea8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5938a0aee12f0660777919dfd71c2c40cfc0672f86b3930120bb182ae9f09543"
    sha256 cellar: :any,                 x86_64_linux:  "9e0c357d42a83edc5127c2fbf9100d3fbdbf533d575cf02bbc46e8dbd8fc29f0"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.Version=#{version}"), "./cmd/ddns"
  end

  service do
    run [opt_bin/"cloudflare-ddns"]
    log_path var/"log/cloudflare-ddns.log"
    error_log_path var/"log/cloudflare-ddns.log"
  end

  test do
    ENV["CLOUDFLARE_API_TOKEN"] = "invalid token"
    ENV["DOMAINS"] = "example.org"
    ENV["UPDATE_CRON"] = "@once"

    output = shell_output(bin/"cloudflare-ddns", 1)
    assert_match version.to_s, output
    assert_match "The API token does not follow the OAuth2 bearer token format", output
  end
end
