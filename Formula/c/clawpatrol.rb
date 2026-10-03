class Clawpatrol < Formula
  desc "Security firewall for agents"
  homepage "https://clawpatrol.dev"
  url "https://github.com/denoland/clawpatrol/archive/refs/tags/v0.5.14.tar.gz"
  sha256 "c2431415b73451f94446220c9825fbfd4c331de057e96f3967955c42c874bc6c"
  license "MIT"
  head "https://github.com/denoland/clawpatrol.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "69dbc26b7d441d4cfca51a13a5e9e0d943b49c68090db82f64b0f97097535698"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "69dbc26b7d441d4cfca51a13a5e9e0d943b49c68090db82f64b0f97097535698"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f6d915762d24f0bd34cc9b21984fff001a3e960dbe788dcaf3784d7e76a11099"
    sha256 cellar: :any,                 x86_64_linux:  "2c376be4c0b2a8cf39c224d47ef502e47e7885dfba2d515c57c38a37d71ce1c9"
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
