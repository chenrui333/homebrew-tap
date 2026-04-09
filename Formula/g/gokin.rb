class Gokin < Formula
  desc "AI-powered CLI assistant for code"
  homepage "https://gokin.ginkida.dev"
  url "https://github.com/ginkida/gokin/archive/refs/tags/v0.57.3.tar.gz"
  sha256 "0941cdf591634ada7dcf5b341803624e7dd1e15075d3b7f991e7efe03447c72b"
  license "MIT"
  head "https://github.com/ginkida/gokin.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "65b43c5a1ee27089c98c673d9cb0ef87857bc4193d8dc175a396266b4f243749"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "65b43c5a1ee27089c98c673d9cb0ef87857bc4193d8dc175a396266b4f243749"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "65b43c5a1ee27089c98c673d9cb0ef87857bc4193d8dc175a396266b4f243749"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3ee1279dc5a5bc978192adbeb37d8da81c9f2e5d98b0347bb9183fa5290d6a9e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "70a26c4093167241448ae9ebc8b33167d3d53dff2c9494358eca81b1ed177119"
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
