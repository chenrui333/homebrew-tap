class Logira < Formula
  desc "Observe-only eBPF tool to record runtime events during AI agent runs"
  homepage "https://github.com/melonattacker/logira"
  url "https://github.com/melonattacker/logira/archive/refs/tags/v0.2.1.tar.gz"
  sha256 "b1970b1f21785f48a88b7180378d3ba4ba4cc12729998996d4ae3f9f6727a67a"
  license "Apache-2.0"
  head "https://github.com/melonattacker/logira.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    manifest_sha256 "996527e573ff7b9a2fed0edd2578961df3ff75a08c2eaae88dbd3a037852f38f"
    sha256 cellar: :any_skip_relocation, arm64_linux:  "7e53fd980c9fa8abb15080ec54c76f91e0941f625917e83173a42ac7a588f342"
    sha256 cellar: :any,                 x86_64_linux: "6762adc894aba1968c4c86b0755b32db6ae7966fda25d8b72ffae04c8aa018e2"
  end

  depends_on "go" => :build
  depends_on :linux

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w", output: bin/"logira"), "./cmd/logira"
    system "go", "build", *std_go_args(ldflags: "-s -w", output: bin/"logirad"), "./cmd/logirad"
  end

  test do
    require "open3"

    # FIXME: Upstream does not expose a version command; replace this with a version assertion when available.
    output, status = Open3.capture2e(bin/"logira", "--not-a-real-option")
    refute_predicate status, :success?
    assert_match "not-a-real-option", output

    ENV["LOGIRA_HOME"] = testpath/"logira"
    assert_equal "[]\n", shell_output("#{bin}/logira runs --json")
    assert_match "(no runs)", shell_output("#{bin}/logira runs")
    assert_predicate testpath/"logira/runs", :directory?
  end
end
