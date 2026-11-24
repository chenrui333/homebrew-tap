class Olla < Formula
  desc "Lightweight & fast AI inference proxy for self-hosted LLMs backends"
  homepage "https://thushan.github.io/olla/"
  url "https://github.com/thushan/olla/archive/refs/tags/v0.2.0.tar.gz"
  sha256 "fbf41ca800d448f537a91c154910a544db4906c597680f1d1cb0c5b9136f99d8"
  license "Apache-2.0"
  head "https://github.com/thushan/olla.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    manifest_sha256 "e045d848f01bb46ea0f35944a974cf7361ac32b1f91ee8e379b1163de514a491"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5f663fc2b4f333f206cfed04a97b7a96757c10975055445a893701f5f19541bf"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5f663fc2b4f333f206cfed04a97b7a96757c10975055445a893701f5f19541bf"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7257cece070df21c0ce6b1b8c20afe5eca2433c0800f2f6c6dfcfaa4dc851607"
    sha256 cellar: :any,                 x86_64_linux:  "056fa7ec616eac07b219371b92b707c6ac20a852a25d28b9bce9668659bd10e8"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = %W[
      -s -w
      -X github.com/thushan/olla/internal/version.Version=v#{version}
      -X github.com/thushan/olla/internal/version.Commit=#{tap.user}
      -X github.com/thushan/olla/internal/version.Date=#{time.iso8601}
      -X github.com/thushan/olla/internal/version.User=#{tap.user}
    ]
    system "go", "build", *std_go_args(ldflags:)
  end

  service do
    run [opt_bin/"olla", "serve"]
    keep_alive true
    working_dir var
    log_path var/"log/olla.log"
    error_log_path var/"log/olla.log"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/olla --version 2>&1")

    (testpath/"config.yaml").write <<~YAML
      server:
        host: "127.0.0.1"
        port: 40114
    YAML
    output = shell_output("#{bin}/olla --validate-config -c #{testpath}/config.yaml 2>&1")
    assert_match "Result: PASS", output
    assert_match "profile(s) loaded", output

    (testpath/"bad.yaml").write <<~YAML
      server:
        port: 99999
    YAML
    output = shell_output("#{bin}/olla --validate-config -c #{testpath}/bad.yaml 2>&1", 1)
    assert_match "server.port must be between 1 and 65535", output
  end
end
