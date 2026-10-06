class Ngtop < Formula
  desc "Nginx access logs analytics"
  homepage "https://github.com/facundoolano/ngtop"
  url "https://github.com/facundoolano/ngtop/archive/refs/tags/v0.4.6.tar.gz"
  sha256 "41fe7b63277c67f521155030e028b53ebc0649fb34919bc31785b0b3723b5c6f"
  license "GPL-3.0-only"
  head "https://github.com/facundoolano/ngtop.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "83a978133d70c9f7d39134b578f00c95410772f5792abea61550b7f8276a83bd"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "880659c9c334b6c2cfcea91518861067c45929cd35f78f903d7bf6e5a31f912c"
    sha256 cellar: :any,                 x86_64_linux:  "563c3a0a27b27355408b5647e77e9856bd48cde104e26482f1e27b8f0736ce22"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ENV["CGO_ENABLED"] = "1" if OS.linux? && Hardware::CPU.arm?

    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ngtop --version")

    assert_match <<~EOS, shell_output("#{bin}/ngtop --limit 1")
      #REQS
      0
    EOS

    now = Time.now.utc.strftime("%d/%b/%Y:%H:%M:%S +0000")
    (testpath/"access.log").write <<~LOG
      1.2.3.4 - - [#{now}] "GET /index.html HTTP/1.1" 200 612 "-" "curl/8.0"
      1.2.3.5 - - [#{now}] "GET /about HTTP/1.1" 200 100 "-" "curl/8.0"
      1.2.3.5 - - [#{now}] "GET /about HTTP/1.1" 404 100 "-" "curl/8.0"
    LOG
    ENV["NGTOP_LOGS_PATH"] = testpath/"access.log"
    ENV["NGTOP_DB"] = testpath/"ngtop.db"
    assert_match(%r{/about\s+2\n/index\.html\s+1}, shell_output("#{bin}/ngtop path"))
    assert_match(/404\s+1/, shell_output("#{bin}/ngtop status"))
  end
end
