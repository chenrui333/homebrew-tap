class Lazyenv < Formula
  desc "TUI tool for managing multiple .env files in the terminal"
  homepage "https://github.com/lazynop/lazyenv"
  url "https://github.com/lazynop/lazyenv/archive/refs/tags/v0.9.0.tar.gz"
  sha256 "e59eca8832e9dec1e5f265efb54424612732aa1f8071daec459bb752fd235a2e"
  license "MIT"
  head "https://github.com/lazynop/lazyenv.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "626ffc9877483dbfb8f7e6f9d1621418a48f69ab346f09d9f1f98658674fb3fe"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "626ffc9877483dbfb8f7e6f9d1621418a48f69ab346f09d9f1f98658674fb3fe"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "626ffc9877483dbfb8f7e6f9d1621418a48f69ab346f09d9f1f98658674fb3fe"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "34256b775590ecef871eca0eff6387e3b6b7462307762545e0010eef7dfb68e9"
    sha256 cellar: :any,                 x86_64_linux:  "5ae6b22c397bb4281f8b0383f1ec6cb99bc465e293a71f58c3d4d5bd5ab85774"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version}"
    system "go", "build", *std_go_args(ldflags:), "."
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/lazyenv --version 2>&1")
  end
end
