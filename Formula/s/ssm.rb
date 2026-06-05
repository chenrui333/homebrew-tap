class Ssm < Formula
  desc "Terminal Secure Shell Manager"
  homepage "https://github.com/lfaoro/ssm"
  url "https://github.com/lfaoro/ssm/archive/refs/tags/2.6.0.tar.gz"
  sha256 "342d3359d80d979858b48b0df1047bc93331c229ad1dbe8cb43dc511ab004007"
  license "BSD-3-Clause"
  head "https://github.com/lfaoro/ssm.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f1922ede72014a864fcbb9d3e23a8ba23a80a7b90b6cf18e0fe6357d3556f6fc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f90dfa2df12fd2415a951a57856c11e4fefbef9c24b61fe90e31a8cfefaf14c0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1013d44f2e3d884ddd28d11a5f67c6fe20cd19d13255040bb3c8e56788d2ca16"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6bfc6ef88efb9a5341a7e03003e87f6df9827cb4368b51113792207be99ecdcb"
    sha256 cellar: :any,                 x86_64_linux:  "00c65b69c6ce20433ded8a521ef21f2a8ef029396bb81527b0658626f7b776d2"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.BuildVersion=#{version} -X main.BuildDate=#{time.iso8601} -X main.BuildSHA=#{tap.user}"
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ssm --version")
  end
end
