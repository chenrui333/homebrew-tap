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
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5c73f80d097ce3d0ed5873e6d680aa5e518508ce7243f32a6bae7ca3535118ad"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5c73f80d097ce3d0ed5873e6d680aa5e518508ce7243f32a6bae7ca3535118ad"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5c73f80d097ce3d0ed5873e6d680aa5e518508ce7243f32a6bae7ca3535118ad"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "97ac89e0dbcee8d216e77179cb0a5994b0f96be577f638f7b384be3e186e6e70"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b48db5df91031caef5d2b18fc5109b5e26b6b9945c791ed0bd30d46552b3a4a4"
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
