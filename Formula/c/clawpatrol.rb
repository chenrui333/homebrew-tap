class Clawpatrol < Formula
  desc "Security firewall for agents"
  homepage "https://clawpatrol.dev"
  url "https://github.com/denoland/clawpatrol/archive/refs/tags/v0.5.8.tar.gz"
  sha256 "380884cb9ed9a0bb80f043c2ac66514ff5c929d92ff13b0efeaf75d3ea663c32"
  license "MIT"
  head "https://github.com/denoland/clawpatrol.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c751513064395b255384c2b0e3811f5bb54d5ef982dd7c5733b4fec239a44ab9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c751513064395b255384c2b0e3811f5bb54d5ef982dd7c5733b4fec239a44ab9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c751513064395b255384c2b0e3811f5bb54d5ef982dd7c5733b4fec239a44ab9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8a9d36497c298a07defbe858b2f22aaaafeb42cd12a6d06d29056fc1ceb13c7d"
    sha256 cellar: :any,                 x86_64_linux:  "2a1bf05b85a18edb12e021adfc5c08a3fe3151836a2d5b4963890f9a36bfd824"
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
