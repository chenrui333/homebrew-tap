class Gokin < Formula
  desc "AI-powered CLI assistant for code"
  homepage "https://gokin.ginkida.dev"
  url "https://github.com/ginkida/gokin/archive/refs/tags/v0.100.80.tar.gz"
  sha256 "8018f0adcfa050ae35559f1cf90cf97118544c76af6f273f2fd9da3d830043a1"
  license "MIT"
  head "https://github.com/ginkida/gokin.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f50c6cc02d3fb1cbe00b534eab6e4c4159d077d76b4e595bd26c323c02c87e3e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f50c6cc02d3fb1cbe00b534eab6e4c4159d077d76b4e595bd26c323c02c87e3e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f50c6cc02d3fb1cbe00b534eab6e4c4159d077d76b4e595bd26c323c02c87e3e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8c705728ddd9489a9f6ece8c4711cf56e6edd61e65d0dda7f0660beae1682363"
    sha256 cellar: :any,                 x86_64_linux:  "3b33783b4814cc87a48509d8c4778b05c19be1f10cc3a42bdeeb86e5bc0a1ed2"
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
