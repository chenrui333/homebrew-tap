class Marchat < Formula
  desc "Terminal chat with WebSockets, E2E encryption, plugins, and file sharing"
  homepage "https://github.com/Cod-e-Codes/marchat"
  url "https://github.com/Cod-e-Codes/marchat/archive/refs/tags/v1.3.8.tar.gz"
  sha256 "0eed729ce60d1ed31f43a0f237bfd908c4ce4396e8ab46b2a355686893edd6b4"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9e8d62d12752a77c5f7a11303e1cca1b4753b0a46c4f01ae37eeca1cafd5a2e5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9e8d62d12752a77c5f7a11303e1cca1b4753b0a46c4f01ae37eeca1cafd5a2e5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b95b75b99df582626ef99b99ef60cd8b05280e5455187d4ea711e20bca3d86b3"
    sha256 cellar: :any,                 x86_64_linux:  "7e917bc7b3a65060c43e19309be6674b5ac9850026d0a6c51757bf647e20d47b"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = %W[
      -s -w
      -X github.com/Cod-e-Codes/marchat/shared.ClientVersion=#{version}
      -X github.com/Cod-e-Codes/marchat/shared.ServerVersion=#{version}
      -X github.com/Cod-e-Codes/marchat/shared.BuildTime=#{time.iso8601}
      -X github.com/Cod-e-Codes/marchat/shared.GitCommit=#{tap.user}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/server"
  end

  test do
    ENV["MARCHAT_ADMIN_KEY"] = "your-generated-key"
    ENV["MARCHAT_USERS"] = "admin1,admin2"
    ENV["MARCHAT_DOCTOR_NO_NETWORK"] = "1"

    report = JSON.parse(shell_output("#{bin}/marchat -doctor-json"))
    assert_equal version.to_s, report["version"]
    checks = report["checks"].to_h { |check| [check["id"], check] }
    assert_equal "ok", checks["config_validate"]["status"]
    assert_match "TLS not configured", checks["tls"]["message"]
    assert_equal "ok", checks["db_ping"]["status"]
    assert report["update"]["skipped"]
  end
end
