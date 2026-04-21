class AwsDoctor < Formula
  desc "Audit AWS security, costs, and best practices"
  homepage "https://awsdoctor.compacompila.com/"
  url "https://github.com/elC0mpa/aws-doctor/archive/refs/tags/v2.9.3.tar.gz"
  sha256 "84ec79734944676da963ad50340cd03874a00c246320bdc883581a1027845789"
  license "MIT"
  head "https://github.com/elC0mpa/aws-doctor.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1a410960620743d927cf73135f684dd714f6ba6ea8f44174d0d2f787cb2f585a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1a410960620743d927cf73135f684dd714f6ba6ea8f44174d0d2f787cb2f585a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1a410960620743d927cf73135f684dd714f6ba6ea8f44174d0d2f787cb2f585a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "10e7993ed1962dae71631ca9435df52f1bb5779fc6d5183e20415f2a84cf9291"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ad478d2866a6de31a6481427389e1305bffaf56c7e8871044f300d2ef26b5725"
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
