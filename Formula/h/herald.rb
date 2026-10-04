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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "90760d15ddec4f001564921f0945e617ac488d62565fdc1e3308e7f836084ccd"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "62c58485988cf8380bb0dde7af0442c40d24d8a88c076716b8ce80e0951012ba"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b65feb3079822657cea2caf019297de0a2893b9a6ee959ffe5e1cde4072bfab6"
    sha256 cellar: :any,                 arm64_linux:   "1f27d3676a794a8409062d1403466d0918d9e2f8540db716b8138449a4050cc4"
    sha256 cellar: :any,                 x86_64_linux:  "29ef4c68a8979aa531dbf45700b13ab787c61573075573f79d36e022c034852c"
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
