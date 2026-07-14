class Gokin < Formula
  desc "AI-powered CLI assistant for code"
  homepage "https://gokin.ginkida.dev"
  url "https://github.com/ginkida/gokin/archive/refs/tags/v0.100.87.tar.gz"
  sha256 "90ac702befbb8db5335b4ca83330a47e1cf83fa7647e756dc674c5bce0e5e260"
  license "MIT"
  head "https://github.com/ginkida/gokin.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2a793b5aa992f3a63afc517dd6f8bf7e5d7bb55284393d06e8fc379a3eb8c9a2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2a793b5aa992f3a63afc517dd6f8bf7e5d7bb55284393d06e8fc379a3eb8c9a2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2a793b5aa992f3a63afc517dd6f8bf7e5d7bb55284393d06e8fc379a3eb8c9a2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "28407fd7a49fcb4f593542ef6acdbbacc526bbb611ca2c2201f9595514b434f3"
    sha256 cellar: :any,                 x86_64_linux:  "e8dce317e11d7f8e5831a0e1fb626933c4d99229a8fd90a7a601977e9bfcc7ee"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/gokin"

    generate_completions_from_executable(bin/"gokin", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gokin version")
    output = shell_output("#{bin}/gokin not-a-real-command 2>&1", 1)
    assert_match "unknown command", output
  end
end
