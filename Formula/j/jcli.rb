class Jcli < Formula
  desc "CLI for jenkins"
  homepage "https://github.com/jenkins-zh/jenkins-cli"
  url "https://github.com/jenkins-zh/jenkins-cli/archive/refs/tags/v0.0.47.tar.gz"
  sha256 "4e78600e214c357c08a0a83fe9cc59214b0d050de07dbb469d9f226c8c37eabc"
  license "MIT"
  head "https://github.com/jenkins-zh/jenkins-cli.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2fc5480f2cc3a5146c364d7bae202e707bf603e9b1ec7e40bcc0face7879954a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3bce35a45c7628d0852ccb8d3cbb3aa6655654845b5d73b335186ef8b0ca890c"
    sha256 cellar: :any_skip_relocation, ventura:       "d7c405f750f5d242f5aca75d85fbede18b4075caa71413f8c6192b0ae407119c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cc40ba1263549e6ad1319a04b18bad9a51b22ca982eb7c35f421bb88b835045f"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/linuxsuren/cobra-extension/version.version=#{version}
      -X github.com/linuxsuren/cobra-extension/version.commit=#{tap.user}
      -X github.com/linuxsuren/cobra-extension/version.date=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"jcli", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/jcli version")

    (testpath/".jenkins-cli.yaml").write <<~EOS
      current: default
      configurations:
        default:
          url: http://localhost:8080
          username: admin
          token: admin
    EOS

    assert_equal "Name URL Description", shell_output("#{bin}/jcli config list").chomp
    assert_match "Cannot found Jenkins", shell_output("#{bin}/jcli plugin list 2>&1", 1)
  end
end
