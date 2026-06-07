class Lazyenv < Formula
  desc "TUI tool for managing multiple .env files in the terminal"
  homepage "https://github.com/lazynop/lazyenv"
  url "https://github.com/lazynop/lazyenv/archive/refs/tags/v0.8.1.tar.gz"
  sha256 "6540ced882b7a5e8c23a1560db7e83ba3657509bb53c8c43d0bd95ebede49ffa"
  license "MIT"
  head "https://github.com/lazynop/lazyenv.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7ca261839221fd8258d358ac9feccdcdd8a8b4a5b8c2c78e788b14c876100804"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7ca261839221fd8258d358ac9feccdcdd8a8b4a5b8c2c78e788b14c876100804"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7ca261839221fd8258d358ac9feccdcdd8a8b4a5b8c2c78e788b14c876100804"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4e3e2c8fcc5d1839029bffb76012ad38a8d24d59a5f0df15b62a54248910721c"
    sha256 cellar: :any,                 x86_64_linux:  "f6dcc446ad56d49db112680fb2fb5bafa94919d85e9308b959f71833dbc68873"
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
