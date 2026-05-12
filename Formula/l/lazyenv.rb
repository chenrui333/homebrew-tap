class Lazyenv < Formula
  desc "TUI tool for managing multiple .env files in the terminal"
  homepage "https://github.com/lazynop/lazyenv"
  url "https://github.com/lazynop/lazyenv/archive/refs/tags/v0.7.1.tar.gz"
  sha256 "8714222bfa945b4f331d29eb6b486b9cdf0d9538650d40445c0575478662f680"
  license "MIT"
  head "https://github.com/lazynop/lazyenv.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "dc0349a2c91aba8beeb575d4de12f1bd8f5a28959e67a8e09c6a7f762a398152"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "dc0349a2c91aba8beeb575d4de12f1bd8f5a28959e67a8e09c6a7f762a398152"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "dc0349a2c91aba8beeb575d4de12f1bd8f5a28959e67a8e09c6a7f762a398152"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9e967f1442498df069645556fefc4fa55675de8eb34e7975fe88d8ff0aae2b61"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "140d9dce119fb69819a28060bd9b5ca60a2c74cb76e798e581e0fbd279345a6c"
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
