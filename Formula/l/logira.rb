class Logira < Formula
  desc "Observe-only eBPF tool to record runtime events during AI agent runs"
  homepage "https://github.com/melonattacker/logira"
  url "https://github.com/melonattacker/logira/archive/refs/tags/v0.1.0.tar.gz"
  sha256 "113b4c260edf95e667769a721e35625c1fde9ee29d6f344b7adf0fef632dab75"
  license "Apache-2.0"
  head "https://github.com/melonattacker/logira.git", branch: "main"

  depends_on "go" => :build
  depends_on :linux

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w", output: bin/"logira"), "./cmd/logira"
    system "go", "build", *std_go_args(ldflags: "-s -w", output: bin/"logirad"), "./cmd/logirad"
  end

  test do
    assert_match "logira", shell_output("#{bin}/logira --help 2>&1").downcase
  end
end
