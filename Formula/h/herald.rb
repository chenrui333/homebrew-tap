class Herald < Formula
  desc "Terminal email and calendar client"
  homepage "https://github.com/herald-email/herald-mail-app"
  url "https://github.com/herald-email/herald-mail-app/archive/refs/tags/v0.9.0-beta.1.tar.gz"
  sha256 "80db83085799c6f1955e7426bf518117c2596dc8e50d39683b80a033db89bc38"
  license "FSL-1.1-ALv2"
  head "https://github.com/herald-email/herald-mail-app.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+(?:-beta\.\d+)?)$/i)
    strategy :github_tags
  end

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "374410bcdb7a0f7d95be632dcef50af1dce489a92727fa433b2b6b8c594a2eff"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bcee521e364ffada0e22a5efccf89c7a306c30f3fcc47f6392acfd0bcc207fa4"
    sha256 cellar: :any,                 arm64_linux:   "fb5bb8a72cc3bf03a382d64940e41b3a67ecb79238c5375477be1a67fd6e912e"
    sha256 cellar: :any,                 x86_64_linux:  "cc1fc9bf8784d42d58d2a3ce2521219e9c40d6b2cabe4d57a06e39b85361dd15"
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
