class Gokin < Formula
  desc "AI-powered CLI assistant for code"
  homepage "https://gokin.ginkida.dev"
  url "https://github.com/ginkida/gokin/archive/refs/tags/v0.83.0.tar.gz"
  sha256 "d16a7e592205eb2c7db6006d5612ba68cbb90277d9e03390ab1673fe21182878"
  license "MIT"
  head "https://github.com/ginkida/gokin.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3645bba8477539352d0107697a937e19757e180a11b5ed6e386a34db9f79179b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3645bba8477539352d0107697a937e19757e180a11b5ed6e386a34db9f79179b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3645bba8477539352d0107697a937e19757e180a11b5ed6e386a34db9f79179b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2f1f11615d238c4b07606c10f8f4bdc4e81860bd15c794f434aa2f9e057ad03b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "71c2cd275241e830754d7decc48f90195cd58cc8c6aa6e2313190c72383f414d"
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
