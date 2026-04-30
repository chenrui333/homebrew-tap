class AwsDoctor < Formula
  desc "Audit AWS security, costs, and best practices"
  homepage "https://awsdoctor.compacompila.com/"
  url "https://github.com/elC0mpa/aws-doctor/archive/refs/tags/v2.13.0.tar.gz"
  sha256 "491d8cfff5f2623414812fd5436fc578a5fca3b02c12ab4d516797582991e62d"
  license "MIT"
  head "https://github.com/elC0mpa/aws-doctor.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2aa263dc878f26b6624d75bd7a5aa8d5bbfce588aaa9d1f9c46fd4150fe429e2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2aa263dc878f26b6624d75bd7a5aa8d5bbfce588aaa9d1f9c46fd4150fe429e2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2aa263dc878f26b6624d75bd7a5aa8d5bbfce588aaa9d1f9c46fd4150fe429e2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c2caf24843c1c2bf88e78159d6330ddf3e71e19a86576d0428cb4a0660dd0503"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d8f3a14fdddc1523f5dc157df8a2dcb86b77c1ed0d960b624eba99c9691dfac0"
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
