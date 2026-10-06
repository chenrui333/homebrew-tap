class Olla < Formula
  desc "Lightweight & fast AI inference proxy for self-hosted LLMs backends"
  homepage "https://thushan.github.io/olla/"
  url "https://github.com/thushan/olla/archive/refs/tags/v0.0.29.tar.gz"
  sha256 "9ae9d83bcb631f592fa987a14468b1a43cefb662f8259da750044d932a14a2d7"
  license "Apache-2.0"
  head "https://github.com/thushan/olla.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "24cea7bec39c3f25476ab2aa9e777cc08622819d19cb69040df523751878a272"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "24cea7bec39c3f25476ab2aa9e777cc08622819d19cb69040df523751878a272"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6be79098baa5bd553215b908ccf7c15f958367aa650fdce0f5fd99d88d0503b6"
    sha256 cellar: :any,                 x86_64_linux:  "2d89138e6ecf84e53edc108d0278033eb11ef244b29142b92f5b582e50510275"
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
