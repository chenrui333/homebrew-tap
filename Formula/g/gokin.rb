class Gokin < Formula
  desc "AI-powered CLI assistant for code"
  homepage "https://gokin.ginkida.dev"
  url "https://github.com/ginkida/gokin/archive/refs/tags/v0.102.2.tar.gz"
  sha256 "540bddafe2b4dad237cbb6ddf15da40d9d45fc9631e39031f2cc3561a255eeda"
  license "MIT"
  head "https://github.com/ginkida/gokin.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b7738a58152066676ddfa102101c519f0bdf706e7fd7799174c7d205ccca56aa"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "36a34bc5b0c544fa1b97743051176bf3351a4bdd067b3259c069e15b87ddde3c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "55c970b145d7431d2c5f9813d43267603f429571045544de18d25a06b5e2654a"
    sha256 cellar: :any,                 x86_64_linux:  "83bfbf94f0beaef4f22a774b629d102f2d38f4b9ce69adfa73d676cc26f8f69c"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = "-s -w -X main.version=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/gokin"

    generate_completions_from_executable(bin/"gokin", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gokin version")
    assert_match "API key not configured", shell_output("#{bin}/gokin doctor")
  end
end
