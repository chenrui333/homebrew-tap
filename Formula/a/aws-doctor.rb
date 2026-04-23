class AwsDoctor < Formula
  desc "Audit AWS security, costs, and best practices"
  homepage "https://awsdoctor.compacompila.com/"
  url "https://github.com/elC0mpa/aws-doctor/archive/refs/tags/v2.11.0.tar.gz"
  sha256 "ae17a6629dd4db22b1e7d9b8b7219676db001bb6a551a9029f9a89f472431248"
  license "MIT"
  head "https://github.com/elC0mpa/aws-doctor.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b3021d65018f47fe4e14ccabc90fc7d7fc5699d75083c798635cafcf4840f2aa"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b3021d65018f47fe4e14ccabc90fc7d7fc5699d75083c798635cafcf4840f2aa"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b3021d65018f47fe4e14ccabc90fc7d7fc5699d75083c798635cafcf4840f2aa"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "29e357f0a8a8ed3370a88e0ba223b4fef0c9a843a66071e35bd4e48d114e00ee"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f129a15bf5cad89f1f867950ee4360c5df3d4485ebc656b4dcf13a138698d17a"
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
