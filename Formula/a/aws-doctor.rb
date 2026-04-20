class AwsDoctor < Formula
  desc "Audit AWS security, costs, and best practices"
  homepage "https://awsdoctor.compacompila.com/"
  url "https://github.com/elC0mpa/aws-doctor/archive/refs/tags/v2.9.2.tar.gz"
  sha256 "bc5e167524004d2ee0841ededc7c44e42466aaf956f210f79710f1027ca8656e"
  license "MIT"
  head "https://github.com/elC0mpa/aws-doctor.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "361e1b56c8c83850c75a716ffe98ed95edb544e3a32cc490f067c9bd1d1d8353"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "361e1b56c8c83850c75a716ffe98ed95edb544e3a32cc490f067c9bd1d1d8353"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "361e1b56c8c83850c75a716ffe98ed95edb544e3a32cc490f067c9bd1d1d8353"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ef8844b0b10883ef263ab39df0a09de687085a46314f6781f007ea9440853447"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5895543341ca2ebb08c3c9c079032bd8fe7c34b0565ac6d489badbd2b2e684b3"
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
