class AwsDoctor < Formula
  desc "Audit AWS security, costs, and best practices"
  homepage "https://awsdoctor.compacompila.com/"
  url "https://github.com/elC0mpa/aws-doctor/archive/refs/tags/v2.22.1.tar.gz"
  sha256 "d9782da46799bb6f7826e7a8ba2fa194ffbe3054dd17c6e8198cb69c89011832"
  license "MIT"
  head "https://github.com/elC0mpa/aws-doctor.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "af5e4759443dae670547b92f4d2401b7af7b8e40a5022699f7e05e7c103e7e08"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "af5e4759443dae670547b92f4d2401b7af7b8e40a5022699f7e05e7c103e7e08"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "58820136adc6037f67ab0337db2236fd897f2ff9a24b67864e495d2bbfde1e22"
    sha256 cellar: :any,                 x86_64_linux:  "8369a768af817d6d3de9c3100460a3ea8c853283724d56a0ab1ee173ff6f5063"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = %W[
      -s
      -w
      -X main.version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:), "."
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/aws-doctor version")
    output = shell_output("#{bin}/aws-doctor --invalid-flag 2>&1", 1)
    assert_match "unknown flag", output
  end
end
