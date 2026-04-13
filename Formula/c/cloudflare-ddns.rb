class CloudflareDdns < Formula
  desc "Small, feature-rich, and robust Cloudflare DDNS updater"
  homepage "https://github.com/favonia/cloudflare-ddns"
  url "https://github.com/favonia/cloudflare-ddns/archive/refs/tags/v1.16.2.tar.gz"
  sha256 "dbf196357e6f7aaf1d83ad5e800012f16708b405c8b0d6f131058d44a175f392"
  license "Apache-2.0" => { with: "LLVM-exception" }
  head "https://github.com/favonia/cloudflare-ddns.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "189a7f7076b69164c7ed68e73e1d5ea3f6df7d4c59236065da0dcf8503d612ac"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "189a7f7076b69164c7ed68e73e1d5ea3f6df7d4c59236065da0dcf8503d612ac"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "189a7f7076b69164c7ed68e73e1d5ea3f6df7d4c59236065da0dcf8503d612ac"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a7b8515163411c589af4665be916e17113198633f26597686d727f8838f1f052"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2bcf75c9b645ec7b0e84fced0abe73da3e9234883d9b332a95cfd0d9283ee566"
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
    assert_match "The Cloudflare API token appears to be invalid", output
    assert_match "Failed to check", output
    assert_match "zone named example.org", output
  end
end
