class CloudflareDdns < Formula
  desc "Small, feature-rich, and robust Cloudflare DDNS updater"
  homepage "https://github.com/favonia/cloudflare-ddns"
  url "https://github.com/favonia/cloudflare-ddns/archive/refs/tags/v1.17.0.tar.gz"
  sha256 "dc32935120768cf31eeff12d792f093ed689ace6713933955536f67c19f150f0"
  license "Apache-2.0" => { with: "LLVM-exception" }
  head "https://github.com/favonia/cloudflare-ddns.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "96a2cc45ff6f5a4fb822f296e8110d44fb912fc3d658b49fe4c2be33b9bed8db"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "96a2cc45ff6f5a4fb822f296e8110d44fb912fc3d658b49fe4c2be33b9bed8db"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "96a2cc45ff6f5a4fb822f296e8110d44fb912fc3d658b49fe4c2be33b9bed8db"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "170099784cedeb11f917599e31c05d833d57a0e1ccbc59712a0373e0c5b44981"
    sha256 cellar: :any,                 x86_64_linux:  "8c833a107b71c1bc7fb7cc69471d685b95d11483efe51e61557cca477879bd7a"
  end

  depends_on "go" => :build

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
