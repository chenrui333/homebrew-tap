class Granted < Formula
  desc "Easiest way to access your cloud"
  homepage "https://granted.dev/"
  url "https://github.com/fwdcloudsec/granted/archive/refs/tags/v0.38.0.tar.gz"
  sha256 "b6e2bc8fda38f55ee4673cc0f3f762e076d2029df1d9a8552681a2aacce88721"
  license "MIT"
  head "https://github.com/fwdcloudsec/granted.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e01e3166379346a656edb8a5567f0bfede6d23076e5b17bd68d9dcdbef0a09ef"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1e1d16ef6d47bebe5ba378b4d01e6aa00dfadbe949ffab195b3279ff3a58b0a9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8f6e95d65590878cb7bf0d25dc372da192f20dfd2cde599eb5b85366a33cc185"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9b393c23adc6be87ad1024db46524103ea5a4db18e3d5f9b9382b8fa41ffad88"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/common-fate/granted/internal/build.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/granted"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/granted --version")

    output = shell_output("#{bin}/granted auth configure 2>&1", 1)
    assert_match "[✘] please provide a url argument", output
  end
end
