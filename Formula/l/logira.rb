class Logira < Formula
  desc "Observe-only eBPF tool to record runtime events during AI agent runs"
  homepage "https://github.com/melonattacker/logira"
  url "https://github.com/melonattacker/logira/archive/refs/tags/v0.1.0.tar.gz"
  sha256 "113b4c260edf95e667769a721e35625c1fde9ee29d6f344b7adf0fef632dab75"
  license "Apache-2.0"
  head "https://github.com/melonattacker/logira.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_linux:  "2928b320fd7d422822a43d72f921787315b69c5a39f397495510254bc16cc927"
    sha256 cellar: :any,                 x86_64_linux: "1f2648082c8f85d88bb1888d49d18f07e44727cf5d46f9ddfd8df08724e21c9b"
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
