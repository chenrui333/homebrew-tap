class Clawpatrol < Formula
  desc "Security firewall for agents"
  homepage "https://clawpatrol.dev"
  url "https://github.com/denoland/clawpatrol/archive/refs/tags/v0.3.2.tar.gz"
  sha256 "9d07c9838324353f732deb709f510f0069a21317e69dbdee59f8206b8192b9ec"
  license "MIT"
  head "https://github.com/denoland/clawpatrol.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "30bb6d5ba9f4e4347cfce47944ba37926bfa1088042e020ae12eb3fae538b0cb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "30bb6d5ba9f4e4347cfce47944ba37926bfa1088042e020ae12eb3fae538b0cb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "30bb6d5ba9f4e4347cfce47944ba37926bfa1088042e020ae12eb3fae538b0cb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "05103591b0a899480c4987dbc3bd56cd7554d35019b88ab14ac9b738bb65532d"
    sha256 cellar: :any,                 x86_64_linux:  "6535b1b1002aff3300601710f42c0aa5b6b50af551ee5fe9122eeb4a70817056"
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
