class Gokin < Formula
  desc "AI-powered CLI assistant for code"
  homepage "https://gokin.ginkida.dev"
  url "https://github.com/ginkida/gokin/archive/refs/tags/v0.84.1.tar.gz"
  sha256 "eeb439a9ad5e358150f3657b5fcc072b4530a995445669348cfac0ae6a4102f8"
  license "MIT"
  head "https://github.com/ginkida/gokin.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f67eda07b5c2bf3958674a875d0251f0f1420e785833108e97af6278bb484349"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f67eda07b5c2bf3958674a875d0251f0f1420e785833108e97af6278bb484349"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f67eda07b5c2bf3958674a875d0251f0f1420e785833108e97af6278bb484349"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "61977fd7aebdfe27cab3c9d423b07111723ac572d3bc240eac107eee547389e1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cc1713ddad188547ef7c4b9c210cb2def93b7ba461cb37fe245640fdf8dd7e2d"
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
