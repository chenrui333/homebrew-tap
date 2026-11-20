class Clawpatrol < Formula
  desc "Security firewall for agents"
  homepage "https://clawpatrol.dev"
  url "https://github.com/denoland/clawpatrol/archive/refs/tags/v0.5.15.tar.gz"
  sha256 "82b0dde2aa20d9af8dcb6fbefcc5e82e4df7614488e53ed887961bbece111594"
  license "MIT"
  head "https://github.com/denoland/clawpatrol.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e2597e206b61e167076f3bcf4646a4c7bd6bc33f82d14aba90b87e8ca46fbf82"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e2597e206b61e167076f3bcf4646a4c7bd6bc33f82d14aba90b87e8ca46fbf82"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8729bbaa0812cc626c9ed76cb35bb248b1c8ea0d86128f0e547688c578594497"
    sha256 cellar: :any,                 x86_64_linux:  "28e8218d674d634acbffe47de50e680c073e76ff3cbd77234698ffda4e630a30"
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

    ldflags = "-X main.buildVersion=#{version}"
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
