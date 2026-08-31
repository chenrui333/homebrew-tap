class Octoscope < Formula
  desc "Terminal dashboard for your GitHub account"
  homepage "https://github.com/gfazioli/octoscope"
  url "https://github.com/gfazioli/octoscope/archive/refs/tags/v0.30.1.tar.gz"
  sha256 "151516902772fc94b5f0c3b591dddda0f49c832a5f2e50836184fb235d554815"
  license "MIT"
  head "https://github.com/gfazioli/octoscope.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1b6b37160cf18db2c879b78e9f390a42e70cd7e609c51849e9210fcab5aebbd9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1b6b37160cf18db2c879b78e9f390a42e70cd7e609c51849e9210fcab5aebbd9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1b6b37160cf18db2c879b78e9f390a42e70cd7e609c51849e9210fcab5aebbd9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9e5a198d9ee298f8a3e3f5b588e115764ab120d58b1efbfd920379df56c3e162"
    sha256 cellar: :any,                 x86_64_linux:  "8c6478dadbe9bab1f2136046b985bcf4f376e13f6d7fce26901e4991c6dc3a23"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "."
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/octoscope --version 2>&1")

    output = shell_output("#{bin}/octoscope --theme invalid 2>&1", 2)
    assert_match 'unknown theme "invalid"', output
  end
end
