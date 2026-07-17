class Clawpatrol < Formula
  desc "Security firewall for agents"
  homepage "https://clawpatrol.dev"
  url "https://github.com/denoland/clawpatrol/archive/refs/tags/v0.5.7.tar.gz"
  sha256 "938e19f6e7fd2a2f7f94304531c21ef0b00069a7538ee500470b033814ff0017"
  license "MIT"
  head "https://github.com/denoland/clawpatrol.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ff6295397f63ff49eee698da627c913e615a9bf8b9203a1279220ce62df6da5f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ff6295397f63ff49eee698da627c913e615a9bf8b9203a1279220ce62df6da5f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ff6295397f63ff49eee698da627c913e615a9bf8b9203a1279220ce62df6da5f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f82bed872ec4fc92d93a05d3fbfd63911f6680a4075b40c45abf61750a0bc504"
    sha256 cellar: :any,                 x86_64_linux:  "1b11152f6299f51551c5da9f3747d4acf410b2091815960e9c695a3f15b5b9a8"
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
