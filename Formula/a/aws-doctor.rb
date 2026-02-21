class AwsDoctor < Formula
  desc "Audit AWS security, costs, and best practices"
  homepage "https://awsdoctor.compacompila.com/"
  url "https://github.com/elC0mpa/aws-doctor/archive/refs/tags/v1.8.1.tar.gz"
  sha256 "841f2470bcd94acefdb22eb47dc2afc223095cba4a3f506d079489dd45ffddc3"
  license "MIT"
  head "https://github.com/elC0mpa/aws-doctor.git", branch: "main"

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
