class Gokin < Formula
  desc "AI-powered CLI assistant for code"
  homepage "https://gokin.ginkida.dev"
  url "https://github.com/ginkida/gokin/archive/refs/tags/v0.45.0.tar.gz"
  sha256 "d2464c524ed097512d096033c714adbfa1aa21aa6f2721fbc22284300ece24fb"
  license "MIT"
  head "https://github.com/ginkida/gokin.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e5cfb60d816aa270dcca5641a6448c7570397ceae84744a6aca22fc526a5ab96"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e5cfb60d816aa270dcca5641a6448c7570397ceae84744a6aca22fc526a5ab96"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e5cfb60d816aa270dcca5641a6448c7570397ceae84744a6aca22fc526a5ab96"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fc3f55c5b12a6c469a0f749629a882accc1506489d96727e23f3f1945a74255a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1d5a25839cedcf51e1d0175435fa42adb0704a5b95450a83ca28cadbef509844"
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
