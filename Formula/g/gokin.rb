class Gokin < Formula
  desc "AI-powered CLI assistant for code"
  homepage "https://gokin.ginkida.dev"
  url "https://github.com/ginkida/gokin/archive/refs/tags/v0.56.1.tar.gz"
  sha256 "e3ecafe4a42f9bc7c53f44f0ae33736cc5549a4cb3cb4af176fe21bd8b05b193"
  license "MIT"
  head "https://github.com/ginkida/gokin.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6722bb6675d1e4879eed64dc122b7134aa172f626fce03560a40d27b4ee2c70b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6722bb6675d1e4879eed64dc122b7134aa172f626fce03560a40d27b4ee2c70b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6722bb6675d1e4879eed64dc122b7134aa172f626fce03560a40d27b4ee2c70b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "437181f96ee0547bcd8ce0ad7a9b4fca6f5c36a90ae3cb9ac84d7f8321334b8f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d5294c837a3d139bf241fb05ab6313986f730f7bc5d44d129e819bb3ae7d431f"
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
