class Gokin < Formula
  desc "AI-powered CLI assistant for code"
  homepage "https://gokin.ginkida.dev"
  url "https://github.com/ginkida/gokin/archive/refs/tags/v0.100.102.tar.gz"
  sha256 "6b41baa95c10eb0b7f3ded0a8cd267f3d05dd56fefd745871370dcfec9c4fadb"
  license "MIT"
  head "https://github.com/ginkida/gokin.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ae18beab0c0c41b5f93d9f3177fec02b790ccb9a78ea3bd6a3fef2e4a3030593"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ae18beab0c0c41b5f93d9f3177fec02b790ccb9a78ea3bd6a3fef2e4a3030593"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ae18beab0c0c41b5f93d9f3177fec02b790ccb9a78ea3bd6a3fef2e4a3030593"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "43a07a252c04f2daec852895bed029e97447bfefd333c3aa453d5ddfecdc1742"
    sha256 cellar: :any,                 x86_64_linux:  "23997d468d668e66ee25096c6c528c2a9d18fe7cc7ed9ea428d397956ea789e5"
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
