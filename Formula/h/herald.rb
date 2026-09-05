class Herald < Formula
  desc "Terminal email and calendar client"
  homepage "https://github.com/herald-email/herald-mail-app"
  url "https://github.com/herald-email/herald-mail-app/archive/refs/tags/v0.7.5-beta.1.tar.gz"
  sha256 "896105ba775beb7e25c317ddd1309ed1695f29372f3f9ad554714b26153488e2"
  # Functional Source License 1.1 with Apache-2.0 future license (FSL-1.1-ALv2).
  license :cannot_represent
  head "https://github.com/herald-email/herald-mail-app.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+(?:-beta\.\d+)?)$/i)
    strategy :github_tags
  end

  depends_on "go" => :build

  def install
    # go-sqlite3 requires cgo on every supported platform.
    ENV["CGO_ENABLED"] = "1"
    ldflags = "-s -w -X github.com/herald-email/herald-mail-app/internal/version.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/herald"
  end

  service do
    run [opt_bin/"herald", "serve"]
    log_path var/"log/herald.log"
    error_log_path var/"log/herald.log"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/herald --version")
    assert_match "Failed to load config", shell_output("#{bin}/herald serve --config #{testpath}/missing.yaml 2>&1", 1)
  end
end
