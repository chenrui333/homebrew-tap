class JenkinsCli < Formula
  desc "CLI for jenkins"
  homepage "https://github.com/jenkins-zh/jenkins-cli"
  url "https://github.com/jenkins-zh/jenkins-cli/archive/refs/tags/v0.0.47.tar.gz"
  sha256 "4e78600e214c357c08a0a83fe9cc59214b0d050de07dbb469d9f226c8c37eabc"
  license "MIT"
  head "https://github.com/jenkins-zh/jenkins-cli.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ad5b764f0d0973ffe2331e853687250714451a10d66a6c113aec69ecc0d2675f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "34841cd262b9b0d5ea55c4f7643c29a827dfe580fc1152c8de06b72f7094b610"
    sha256 cellar: :any_skip_relocation, ventura:       "9074b2643178057df4cbe4d01c306cbeddfa79b43e0822afcdc9a5d56d89aba6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1e42cf81b71187ee8b8966bc35b021fd4e5b0d1f3d94f2e7427cf51b527b034c"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/linuxsuren/cobra-extension/version.version=#{version}
      -X github.com/linuxsuren/cobra-extension/version.commit=#{tap.user}
      -X github.com/linuxsuren/cobra-extension/version.date=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:, output: bin/"jcli")

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
