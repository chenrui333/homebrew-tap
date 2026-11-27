class Herald < Formula
  desc "Terminal email and calendar client"
  homepage "https://github.com/herald-email/herald-mail-app"
  url "https://github.com/herald-email/herald-mail-app/archive/refs/tags/v0.12.0-beta.1.tar.gz"
  sha256 "264f12ce9fb0b7852b033fd15714ace3219ae88900057a02171c4552944d4f7f"
  license "FSL-1.1-ALv2"
  head "https://github.com/herald-email/herald-mail-app.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+(?:-beta\.\d+)?)$/i)
    strategy :github_tags
  end

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    manifest_sha256 "4e0c46d517673a04060a05855a698c139ee32b9ee2d4c41e13a1f4f2079cad4a"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "23bc854fff87d07b0b7d0e3fe1997c44b5fe41b06f3c38249b17923dd6859114"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ddc4d983b83dc9080278af561aa425997a3d7473bfd37e958264d664d9e46a34"
    sha256 cellar: :any,                 arm64_linux:   "b182ff748ef79909bfa77ebdac6334f38d2f854cc1ec2f0897af474f1ab63970"
    sha256 cellar: :any,                 x86_64_linux:  "77b5dbcf22d615337ff1c7f6c198f30a5b2408f1a8a117a02b8ef6b10f740821"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    # go-sqlite3 requires cgo on every supported platform.
    ENV["CGO_ENABLED"] = "1"
    ldflags = "-X github.com/herald-email/herald-mail-app/internal/version.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/herald"
  end

  service do
    run [opt_bin/"herald", "serve"]
    log_path var/"log/herald.log"
    error_log_path var/"log/herald.log"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/herald --version")
    output = shell_output("#{bin}/herald serve --config #{testpath}/missing.yaml 2>&1", 1)
    assert_match "Failed to load config", output
  end
end
