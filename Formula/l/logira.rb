class Logira < Formula
  desc "Observe-only eBPF tool to record runtime events during AI agent runs"
  homepage "https://github.com/melonattacker/logira"
  url "https://github.com/melonattacker/logira/archive/refs/tags/v0.1.0.tar.gz"
  sha256 "113b4c260edf95e667769a721e35625c1fde9ee29d6f344b7adf0fef632dab75"
  license "Apache-2.0"
  head "https://github.com/melonattacker/logira.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_linux:  "b3fb4d93c7e07c1558e60f0f646dd9d9a0d092f3902650bbe1fc33ca7a141b73"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "f8d9ad278946b654f09fcff70d3d4df7a7bf68315f768e5642fb517ba0d1787d"
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
