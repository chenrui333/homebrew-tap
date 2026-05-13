class AwsDoctor < Formula
  desc "Audit AWS security, costs, and best practices"
  homepage "https://awsdoctor.compacompila.com/"
  url "https://github.com/elC0mpa/aws-doctor/archive/refs/tags/v2.16.0.tar.gz"
  sha256 "b17580937f16eb5183dfa7cea7d99bcd4bddf466f51152ab96c8cac491d37fd1"
  license "MIT"
  head "https://github.com/elC0mpa/aws-doctor.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8f5193574bf796c052da0456862881d3287b5e04a93c6c95f48a374bed55d92f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8f5193574bf796c052da0456862881d3287b5e04a93c6c95f48a374bed55d92f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8f5193574bf796c052da0456862881d3287b5e04a93c6c95f48a374bed55d92f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d42084cd880b604e0d2c90449d52f863b20a976b2b0243b2edb44c8370199e91"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "adc972c293a556f320f8d979bc6be608765e5c99fe7d6c768cce0200c8cb137f"
  end

  depends_on "go" => :build

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
