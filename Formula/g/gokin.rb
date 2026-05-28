class Gokin < Formula
  desc "AI-powered CLI assistant for code"
  homepage "https://gokin.ginkida.dev"
  url "https://github.com/ginkida/gokin/archive/refs/tags/v0.85.8.tar.gz"
  sha256 "e2b9cdd7d3e237ad600a07ee01bce7d0c9b771660b7f403a53a80632ed3758a1"
  license "MIT"
  head "https://github.com/ginkida/gokin.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fbdd3436276a5474aa84217167840b85ab98cbf26b45e2cd3ec09402d0fb7d8c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fbdd3436276a5474aa84217167840b85ab98cbf26b45e2cd3ec09402d0fb7d8c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fbdd3436276a5474aa84217167840b85ab98cbf26b45e2cd3ec09402d0fb7d8c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "00938c509402878ef7281b2fdea72b92e1000d782893e8413511153720539eec"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "97ead5e4bdde13850397cbfa603a1d6d6c81f453e16fe1062d0a43993a3a47a0"
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
