class Kctx < Formula
  desc "Kubernetes context engine for humans and AI agents"
  homepage "https://github.com/lucasepe/kctx"
  url "https://github.com/lucasepe/kctx/archive/refs/tags/v0.2.1.tar.gz"
  sha256 "eb53f1ecfa479f236319f6cb7f3283e10dc78e4b482ec4d3c32dd1b648efbc44"
  license "Apache-2.0"
  head "https://github.com/lucasepe/kctx.git", branch: "main"

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.Version=v#{version}
    ]
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    output = shell_output("#{bin}/kctx 2>&1")
    assert_match version.to_s, output
    assert_match "dump", output
  end
end
