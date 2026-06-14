class Logira < Formula
  desc "Observe-only eBPF tool to record runtime events during AI agent runs"
  homepage "https://github.com/melonattacker/logira"
  url "https://github.com/melonattacker/logira/archive/refs/tags/v0.1.0.tar.gz"
  sha256 "113b4c260edf95e667769a721e35625c1fde9ee29d6f344b7adf0fef632dab75"
  license "Apache-2.0"
  head "https://github.com/melonattacker/logira.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_linux:  "05128dbe67e7136d7a32eea679c7b328be5167137e0f98076ba1b55177bd1e83"
    sha256 cellar: :any,                 x86_64_linux: "b7697287409b03f46524a31cce3def0b048eec62324d8f4d96508dff462db182"
  end

  depends_on "go" => :build
  depends_on :linux

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
  end
end
