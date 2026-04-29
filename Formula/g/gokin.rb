class Gokin < Formula
  desc "AI-powered CLI assistant for code"
  homepage "https://gokin.ginkida.dev"
  url "https://github.com/ginkida/gokin/archive/refs/tags/v0.78.25.tar.gz"
  sha256 "b8516333a06d4cc026c7f68d46708388504783faf7a9c3ed59e5543a3abf86b7"
  license "MIT"
  head "https://github.com/ginkida/gokin.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b8fee52726c20b9dcb7e584152883e57dd9b97cdd7aa4247d51d61c32029aaed"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b8fee52726c20b9dcb7e584152883e57dd9b97cdd7aa4247d51d61c32029aaed"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b8fee52726c20b9dcb7e584152883e57dd9b97cdd7aa4247d51d61c32029aaed"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "103b6f8cd78471dec9863125ee418b9624eff2eead6587ca98db6d7419b6aa0f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "081385fedfe25b6e45cb9a6c1e004035999bbebecd32218e3b5c78f5d04bf9e3"
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
