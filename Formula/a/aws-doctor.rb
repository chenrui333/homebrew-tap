class AwsDoctor < Formula
  desc "Audit AWS security, costs, and best practices"
  homepage "https://awsdoctor.compacompila.com/"
  url "https://github.com/elC0mpa/aws-doctor/archive/refs/tags/v1.10.2.tar.gz"
  sha256 "51200abc7fe270754d2df1d6a5078a6a9d74f4064eca0425efb6515b4969f524"
  license "MIT"
  head "https://github.com/elC0mpa/aws-doctor.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5723c633449675bd1d9aca508e4f8a93448c0544537468f4d51bbd449650e39c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5723c633449675bd1d9aca508e4f8a93448c0544537468f4d51bbd449650e39c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5723c633449675bd1d9aca508e4f8a93448c0544537468f4d51bbd449650e39c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f8296b0e8300f357e7337042e6ada9f1a8dcecdb06ccffd4f6670b0996dbe070"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7f16cd9106f6be07fd0522533fe89a2a530f423012c5d384ae5a81d911812372"
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
    assert_match version.to_s, shell_output("#{bin}/aws-doctor --version")
    output = shell_output("#{bin}/aws-doctor --invalid-flag 2>&1", 1)
    assert_match "flag provided but not defined", output
  end
end
