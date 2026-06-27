class Clawpatrol < Formula
  desc "Security firewall for agents"
  homepage "https://clawpatrol.dev"
  url "https://github.com/denoland/clawpatrol/archive/refs/tags/v0.5.3.tar.gz"
  sha256 "4f7a9e96e409f5f3618ad0af755e0c4f1c1ef2b7e55dc43d75281ef8df66cddf"
  license "MIT"
  head "https://github.com/denoland/clawpatrol.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "cca458a5d9312b2dd61209b3ebb3b6b7234bfd40a4b280103df9bb2c55a026c5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cca458a5d9312b2dd61209b3ebb3b6b7234bfd40a4b280103df9bb2c55a026c5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cca458a5d9312b2dd61209b3ebb3b6b7234bfd40a4b280103df9bb2c55a026c5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f13f4d2c1df05045b2567984379d9d3b667ddef409388321f9d3d39e56842d26"
    sha256 cellar: :any,                 x86_64_linux:  "9707b9e7666f75e5b0b3994f8b95796dfd1d5407fc7ad53da075d7f608695277"
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
