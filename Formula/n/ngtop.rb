class Ngtop < Formula
  desc "Nginx access logs analytics"
  homepage "https://github.com/facundoolano/ngtop"
  url "https://github.com/facundoolano/ngtop/archive/refs/tags/v0.4.6.tar.gz"
  sha256 "41fe7b63277c67f521155030e028b53ebc0649fb34919bc31785b0b3723b5c6f"
  license "GPL-3.0-only"
  head "https://github.com/facundoolano/ngtop.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c8c2c599d6f70a32f1a65ada3452ae5cd835d845996bbaa2598e0303a258b64e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "46336a70c7097ff46f57ab4b6e349a95968f680eb817112b1ffab845d929697e"
    sha256 cellar: :any,                 arm64_linux:   "5dbde352647bbcfdd2309d9b31166edad37331b0a0de0e4b17f88a960226c7e9"
    sha256 cellar: :any,                 x86_64_linux:  "9f555d2520b8eb0b290f38d96a42b03afdd0ffff08ab6367e5ab50992ad2ba67"
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
