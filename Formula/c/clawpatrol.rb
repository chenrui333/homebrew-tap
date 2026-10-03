class Clawpatrol < Formula
  desc "Security firewall for agents"
  homepage "https://clawpatrol.dev"
  url "https://github.com/denoland/clawpatrol/archive/refs/tags/v0.5.13.tar.gz"
  sha256 "56b08d8537214855d3c2d16b8fd33543e38aa53aa44c2abdd8c2a967dce7fca4"
  license "MIT"
  head "https://github.com/denoland/clawpatrol.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "16ce2e04ed340cd1563512be18ee4db269ab393b82efb4dc4e31ebc0286217f9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "16ce2e04ed340cd1563512be18ee4db269ab393b82efb4dc4e31ebc0286217f9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "eb9bd019ea3bb68015988ffaaa5419b0739c35921bfd39af8526d1d72fde8787"
    sha256 cellar: :any,                 x86_64_linux:  "c1655adc6e3c07c744a74b2d5c3f2b4a35e645a7aa9dd57cb4429e892c3f9011"
  end

  depends_on "deno" => :build
  depends_on "go@1.26" => :build

  deny_network_access!

  def fetch
    ENV["DENO_DIR"] = buildpath/".deno"

    cd "dashboard" do
      system "deno", "install"
    end
    system "go", "mod", "download"
  end

  def install
    ENV["DENO_DIR"] = buildpath/".deno"

    cd "dashboard" do
      system "deno", "install", "--cached-only"
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
