class Herald < Formula
  desc "Terminal email and calendar client"
  homepage "https://github.com/herald-email/herald-mail-app"
  url "https://github.com/herald-email/herald-mail-app/archive/refs/tags/v0.7.5-beta.1.tar.gz"
  sha256 "896105ba775beb7e25c317ddd1309ed1695f29372f3f9ad554714b26153488e2"
  license "FSL-1.1-ALv2"
  head "https://github.com/herald-email/herald-mail-app.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+(?:-beta\.\d+)?)$/i)
    strategy :github_tags
  end

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "01c08a2f3f7e03adf2bb51fb6dc63dc48b8d0b360632862aae2724d8f2541565"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "51e46d6602bcb695cddbd1194e77bd5c54745d77b06fb24f89236d5d634cf129"
    sha256 cellar: :any,                 arm64_linux:   "2f3b15691ec17c571736db726aae6cede37ba45935b5c8c0157a66aa3d5494af"
    sha256 cellar: :any,                 x86_64_linux:  "b4aab0adc9f86a15047031a64b9557264f8213d556a9e56879c273c5ebf01778"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

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
    output = shell_output("#{bin}/herald serve --config #{testpath}/missing.yaml 2>&1", 1)
    assert_match "Failed to load config", output
  end
end
