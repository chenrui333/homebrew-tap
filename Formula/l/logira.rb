class Logira < Formula
  desc "Observe-only eBPF tool to record runtime events during AI agent runs"
  homepage "https://github.com/melonattacker/logira"
  url "https://github.com/melonattacker/logira/archive/refs/tags/v0.2.1.tar.gz"
  sha256 "b1970b1f21785f48a88b7180378d3ba4ba4cc12729998996d4ae3f9f6727a67a"
  license "Apache-2.0"
  head "https://github.com/melonattacker/logira.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_linux:  "eb9aeb48ada357eb0761676003081ab087306ca460009a0d4450d2d77db1473b"
    sha256 cellar: :any,                 x86_64_linux: "45117e00a189fb89aa0d7ae8135efea7a4692f4e165bd75ff75f319efcc4c2ad"
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
