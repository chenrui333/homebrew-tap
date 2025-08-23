class CloudflareDdns < Formula
  desc "Small, feature-rich, and robust Cloudflare DDNS updater"
  homepage "https://github.com/favonia/cloudflare-ddns"
  url "https://github.com/favonia/cloudflare-ddns/archive/refs/tags/v1.15.1.tar.gz"
  sha256 "8f2288e84257a445934e02500db2b778e17e41d0be059a38170ec8bfff6caa1d"
  license "Apache-2.0" => { with: "LLVM-exception" }
  head "https://github.com/favonia/cloudflare-ddns.git", branch: "main"

  depends_on "go" => :build

  def install
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
