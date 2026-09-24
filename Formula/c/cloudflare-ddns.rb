class CloudflareDdns < Formula
  desc "Small, feature-rich, and robust Cloudflare DDNS updater"
  homepage "https://github.com/favonia/cloudflare-ddns"
  url "https://github.com/favonia/cloudflare-ddns/archive/refs/tags/v1.17.1.tar.gz"
  sha256 "62ecb57a236140823e867f29e4f4ab01f6f2f55e56f1782116b750a16e69be10"
  license "Apache-2.0" => { with: "LLVM-exception" }
  head "https://github.com/favonia/cloudflare-ddns.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "bdf0ea37d1fc6e0f73f4a509dc51def0ebce266871ccdb33391799dfbaa1ca41"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bdf0ea37d1fc6e0f73f4a509dc51def0ebce266871ccdb33391799dfbaa1ca41"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cff2a42a3651f77ccb2762a689d9ffce7400c62346bdbebc2ac91dae7816630f"
    sha256 cellar: :any,                 x86_64_linux:  "a834a5e360084cd1141aa883f457dc69ce6c3bbd42b137b2f0da42de4590f855"
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
