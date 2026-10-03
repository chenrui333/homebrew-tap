class Clawpatrol < Formula
  desc "Security firewall for agents"
  homepage "https://clawpatrol.dev"
  url "https://github.com/denoland/clawpatrol/archive/refs/tags/v0.5.14.tar.gz"
  sha256 "c2431415b73451f94446220c9825fbfd4c331de057e96f3967955c42c874bc6c"
  license "MIT"
  head "https://github.com/denoland/clawpatrol.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a688a76d725d1e15f8880b5eec7e3834fdb8050454a96bdfb1be97fa81a1f062"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a688a76d725d1e15f8880b5eec7e3834fdb8050454a96bdfb1be97fa81a1f062"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8ba924a495ed0aec2528e456b10e27bd40ffbbe882d47142d429918c8e32b5fd"
    sha256 cellar: :any,                 x86_64_linux:  "464b48197d930cd1a644dd6056d3aad78c18fd87d642dda45a7934bef326c44c"
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
