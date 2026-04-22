class Gokin < Formula
  desc "AI-powered CLI assistant for code"
  homepage "https://gokin.ginkida.dev"
  url "https://github.com/ginkida/gokin/archive/refs/tags/v0.69.3.tar.gz"
  sha256 "3048aefc8f328c899da0dbc8ef040520445b6d7aa9112f509717cb9938906ad5"
  license "MIT"
  head "https://github.com/ginkida/gokin.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5e59e8e9d1ffe2ea708f099a3efae43fd76ff71f9e06c37c3f61d0ca443198ab"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5e59e8e9d1ffe2ea708f099a3efae43fd76ff71f9e06c37c3f61d0ca443198ab"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5e59e8e9d1ffe2ea708f099a3efae43fd76ff71f9e06c37c3f61d0ca443198ab"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e373337061b45400603102d85fc375a40b5b2b1815ff894b4a03c63fac455471"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a8d212439cb4fbc6724c5a75d2503d3e01312970cfceab003c16fc9f564e850a"
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
