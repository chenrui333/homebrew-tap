class Clawpatrol < Formula
  desc "Security firewall for agents"
  homepage "https://clawpatrol.dev"
  url "https://github.com/denoland/clawpatrol/archive/refs/tags/v0.5.1.tar.gz"
  sha256 "8a30e18703e74689bec54a982caad5544f1ed0f1556204525e2ed23a1fd086bd"
  license "MIT"
  head "https://github.com/denoland/clawpatrol.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ef9da17601dc5f6a0fbf9e6bb6cb7d55d8b8fb9d6d6675507be0b4424b17e19f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ef9da17601dc5f6a0fbf9e6bb6cb7d55d8b8fb9d6d6675507be0b4424b17e19f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ef9da17601dc5f6a0fbf9e6bb6cb7d55d8b8fb9d6d6675507be0b4424b17e19f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d41600fa68ea2e5ea9a069f13063f6e6f322f4409e3f38ae9d30356fc883a208"
    sha256 cellar: :any,                 x86_64_linux:  "30dba8d421caaee8b1bd28f2288ab92854c6fcf5f752a81653a120ec4c01bff9"
  end

  depends_on "deno" => :build
  depends_on "go" => :build

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
