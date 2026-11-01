class Olla < Formula
  desc "Lightweight & fast AI inference proxy for self-hosted LLMs backends"
  homepage "https://thushan.github.io/olla/"
  url "https://github.com/thushan/olla/archive/refs/tags/v0.1.0.tar.gz"
  sha256 "1366fa959ee4523658209ffd72c17221d373b569391958cd2da7c7b004cf6aa8"
  license "Apache-2.0"
  head "https://github.com/thushan/olla.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "aa202828d9bb3906514d32f9e02799f5a9c7b9f056e0e6c7c708829d1b2e3df2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "aa202828d9bb3906514d32f9e02799f5a9c7b9f056e0e6c7c708829d1b2e3df2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e58ae0a41f3459bd6f0b711b9fff3bd0be391bb78042a6383635b2f63710f5a6"
    sha256 cellar: :any,                 x86_64_linux:  "1a180fcb76a3ebfe0a9db615fa6a073459743d36fd9c9b6fc911ec369fd2cbd5"
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
