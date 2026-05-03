class AwsDoctor < Formula
  desc "Audit AWS security, costs, and best practices"
  homepage "https://awsdoctor.compacompila.com/"
  url "https://github.com/elC0mpa/aws-doctor/archive/refs/tags/v2.15.0.tar.gz"
  sha256 "90fb45c9008bf4eb2374b7f3213cdb9965d6e50fc6590f88547b89986cca7a2d"
  license "MIT"
  head "https://github.com/elC0mpa/aws-doctor.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1e62b62c67ba7b23952eb7739f3e71ba7b28cdc6b616df38993268243d5a4af8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1e62b62c67ba7b23952eb7739f3e71ba7b28cdc6b616df38993268243d5a4af8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1e62b62c67ba7b23952eb7739f3e71ba7b28cdc6b616df38993268243d5a4af8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9da403b9a67e47ea6772ce871ad4b55f0f3996e433283c031cb16adcb8d9f758"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f119183edfcb9e6b7cd0374f3352f38093948e8e5b06dcf692025ba3bce1f9cd"
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
