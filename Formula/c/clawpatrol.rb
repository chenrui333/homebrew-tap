class Clawpatrol < Formula
  desc "Security firewall for agents"
  homepage "https://clawpatrol.dev"
  url "https://github.com/denoland/clawpatrol/archive/refs/tags/v0.2.8.tar.gz"
  sha256 "6b434eac675cef2408d7fbc02ae194d23c1a364f6327c9a1d75d23deb854868b"
  license "MIT"
  head "https://github.com/denoland/clawpatrol.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0cec4bd23f366175948225b4fc75b0ca64dbd1d78bb28b1c3afbd771355b2c4f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0cec4bd23f366175948225b4fc75b0ca64dbd1d78bb28b1c3afbd771355b2c4f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0cec4bd23f366175948225b4fc75b0ca64dbd1d78bb28b1c3afbd771355b2c4f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4da3ffe409b2a42995c38c7ec5f3a1f3993c174f84faaecbd4f336b6d820e9e7"
    sha256 cellar: :any,                 x86_64_linux:  "cef2fc2d606da18ff01e166d45968ca4fd1ae66df6ab89bb22a1eb9ba71e2c15"
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
