class Gokin < Formula
  desc "AI-powered CLI assistant for code"
  homepage "https://gokin.ginkida.dev"
  url "https://github.com/ginkida/gokin/archive/refs/tags/v0.65.0.tar.gz"
  sha256 "7ad31a898d32396fd7731fa97b4c0dd4f9d9e63f8350a9351b4e962524c7ec18"
  license "MIT"
  head "https://github.com/ginkida/gokin.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f5ea79e51552adab1e02d6352a8a2558d29aa5bce3cd504800c8d47283a93c56"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f5ea79e51552adab1e02d6352a8a2558d29aa5bce3cd504800c8d47283a93c56"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f5ea79e51552adab1e02d6352a8a2558d29aa5bce3cd504800c8d47283a93c56"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c7b788912c948b1ee2b16ced65a29ecceb9f7d4ef348b41988b6fd10f8f6a3eb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9deeb2b9f69c6f93d681963de616c2f432531ec23ac7bcbba9420835ce2714d8"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/gokin"

    generate_completions_from_executable(bin/"gokin", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gokin version")
    assert_match "Available Commands:", shell_output("#{bin}/gokin --help")
  end
end
