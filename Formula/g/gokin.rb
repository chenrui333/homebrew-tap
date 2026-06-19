class Gokin < Formula
  desc "AI-powered CLI assistant for code"
  homepage "https://gokin.ginkida.dev"
  url "https://github.com/ginkida/gokin/archive/refs/tags/v0.100.43.tar.gz"
  sha256 "b9fe91338a4a4c77856cb55d9e044d13cee81bb3ab9a63c0fc8cdaf594570504"
  license "MIT"
  head "https://github.com/ginkida/gokin.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "04affca4e226e865c3866027d6ca226a329929f4bd37559e0f9634fe37b8c032"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "04affca4e226e865c3866027d6ca226a329929f4bd37559e0f9634fe37b8c032"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "04affca4e226e865c3866027d6ca226a329929f4bd37559e0f9634fe37b8c032"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0a86772a9b97eaa3494296549a69e21e0006dfa28a7a18a469df35ca0c5f4848"
    sha256 cellar: :any,                 x86_64_linux:  "29b5c3ed7bc4e403cfce6882d193e3d8cd73bd084de7971956a30b1f0b00a643"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/gokin"

    generate_completions_from_executable(bin/"gokin", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gokin version")
    output = shell_output("#{bin}/gokin not-a-real-command 2>&1", 1)
    assert_match "unknown command", output
  end
end
