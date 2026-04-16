class AwsDoctor < Formula
  desc "Audit AWS security, costs, and best practices"
  homepage "https://awsdoctor.compacompila.com/"
  url "https://github.com/elC0mpa/aws-doctor/archive/refs/tags/v2.8.0.tar.gz"
  sha256 "c88867d5e62fd9bc2fa1f9033b8765a690163553134ad603ec105c960374db28"
  license "MIT"
  head "https://github.com/elC0mpa/aws-doctor.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1c9ac56daf27b887251e52b3264f68c850657033829be311c0cbaac777deaff6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1c9ac56daf27b887251e52b3264f68c850657033829be311c0cbaac777deaff6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1c9ac56daf27b887251e52b3264f68c850657033829be311c0cbaac777deaff6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9b5fc36c95fa312535f3376f4875b954c51a03441be9452989e80a0fd53b4731"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a9b8d56057bfdfc37b7ed1ce8fdf09228c4b67386c32593f249e6dad9eea0b90"
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
