class Clawpatrol < Formula
  desc "Security firewall for agents"
  homepage "https://clawpatrol.dev"
  url "https://github.com/denoland/clawpatrol/archive/refs/tags/v0.5.3.tar.gz"
  sha256 "4f7a9e96e409f5f3618ad0af755e0c4f1c1ef2b7e55dc43d75281ef8df66cddf"
  license "MIT"
  head "https://github.com/denoland/clawpatrol.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "18d21cb961d614ede9a4270ed783cab4a13e39784ef6440defeae16e6ab07253"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "18d21cb961d614ede9a4270ed783cab4a13e39784ef6440defeae16e6ab07253"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "18d21cb961d614ede9a4270ed783cab4a13e39784ef6440defeae16e6ab07253"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "37b4d139618fabd29688acf5767afd789ca1f1a8b561db67bfcaf211ed4624be"
    sha256 cellar: :any,                 x86_64_linux:  "c214885ef064679bdf63c7265caae84df5d07253d43d98e9b1f0f36865fc13a7"
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
