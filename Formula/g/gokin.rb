class Gokin < Formula
  desc "AI-powered CLI assistant for code"
  homepage "https://gokin.ginkida.dev"
  url "https://github.com/ginkida/gokin/archive/refs/tags/v0.80.27.tar.gz"
  sha256 "73fa71f2465e9d4cd6eca0cf8b705aa5ae1f4883ab794a02a4f166ac4862f19b"
  license "MIT"
  head "https://github.com/ginkida/gokin.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9b355229e02e0ee40cc68d47f6c2a28d27ced84d32beb85f54ba605e64e66bea"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9b355229e02e0ee40cc68d47f6c2a28d27ced84d32beb85f54ba605e64e66bea"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9b355229e02e0ee40cc68d47f6c2a28d27ced84d32beb85f54ba605e64e66bea"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6fc686f24352563d5d708f02ba197369180e8bfa104365b1a945a6e8961207ff"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9a209ee8fd1871a569aae3b95ba9b2f26be30971e29a3526bcdcb1cbf91d6aca"
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
