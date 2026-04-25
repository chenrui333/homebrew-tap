class Gokin < Formula
  desc "AI-powered CLI assistant for code"
  homepage "https://gokin.ginkida.dev"
  url "https://github.com/ginkida/gokin/archive/refs/tags/v0.78.1.tar.gz"
  sha256 "7366080f871123f74b60b24062a6631122864fc25c1fb9ad8a817b8778fa4d26"
  license "MIT"
  head "https://github.com/ginkida/gokin.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "95fe35510f7c783e93d44dae17effd9d9d002a5fb5c5dcb340e8283930c432ca"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "95fe35510f7c783e93d44dae17effd9d9d002a5fb5c5dcb340e8283930c432ca"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "95fe35510f7c783e93d44dae17effd9d9d002a5fb5c5dcb340e8283930c432ca"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6b90b1cafb971ec796be98c05432e9c8728f44b5cbfbc9d2926bed24ca7c4938"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "48216dc9a5232eed3f372ba703e5a521d730688ba0f23ec5d67a6a56d9778139"
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
