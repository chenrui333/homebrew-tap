class CloudflareDdns < Formula
  desc "Small, feature-rich, and robust Cloudflare DDNS updater"
  homepage "https://github.com/favonia/cloudflare-ddns"
  url "https://github.com/favonia/cloudflare-ddns/archive/refs/tags/v1.15.1.tar.gz"
  sha256 "8f2288e84257a445934e02500db2b778e17e41d0be059a38170ec8bfff6caa1d"
  license "Apache-2.0" => { with: "LLVM-exception" }
  head "https://github.com/favonia/cloudflare-ddns.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e8438ef7b6e83af7446aa80b466c6a71660797033c35647adb549c4540bc7187"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6023b280ac9d28aa7715132213c48eef55b67bf081828fb0488d0b318079a995"
    sha256 cellar: :any_skip_relocation, ventura:       "f4a843c0b11fab977a27f435ff3c5686860b35b63aaf40afb4216f7d2c0b5743"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "74b9947ea6c56dab19f14324354770a7345102bb121a9d15084fc69d000f411d"
  end

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
