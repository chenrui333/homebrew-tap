class Clawpatrol < Formula
  desc "Security firewall for agents"
  homepage "https://clawpatrol.dev"
  url "https://github.com/denoland/clawpatrol/archive/refs/tags/v0.5.10.tar.gz"
  sha256 "2d9fc0a7f191ce89f12153a4380d823e55f034e65ee5a5ccc225a511b7b5d020"
  license "MIT"
  head "https://github.com/denoland/clawpatrol.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "93832a79a3b2096cd25dac4bcc055559b80fb71dda3ab075072f15ab7a6384d3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "93832a79a3b2096cd25dac4bcc055559b80fb71dda3ab075072f15ab7a6384d3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "728570017e65a64d5cd424de459dd00dffea1fc9804a09d4e901d774650471c9"
    sha256 cellar: :any,                 x86_64_linux:  "24c194f1e86fcd4ba2137267ca85787c889b34407e9f8f84724fb6fd604bd7b5"
  end

  depends_on "deno" => :build
  depends_on "go@1.26" => :build

  def install
    ENV["DENO_DIR"] = buildpath/".deno"

    cd "dashboard" do
      system "deno", "install"
      system "deno", "task", "build"
    end

    ldflags = "-s -w -X main.buildVersion=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/clawpatrol"

    pkgshare.install "examples"
  end

  service do
    run [opt_bin/"clawpatrol", "gateway", etc/"clawpatrol/gateway.hcl"]
    keep_alive true
    working_dir var/"clawpatrol"
    log_path var/"log/clawpatrol.log"
    error_log_path var/"log/clawpatrol.log"
  end

  def caveats
    <<~EOS
      Example gateway configs are installed under:
        #{opt_pkgshare}/examples

      To run the gateway service, create:
        #{etc}/clawpatrol/gateway.hcl
    EOS
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/clawpatrol version")

    cp_r pkgshare/"examples", testpath
    output = shell_output("#{bin}/clawpatrol validate #{testpath}/examples/protocol-https.hcl")
    assert_match "ok:", output
    assert_match "1 endpoints across 1 profile(s)", output
  end
end
