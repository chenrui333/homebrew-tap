class Karmor < Formula
  desc "Query git repositories with SQL"
  homepage "https://github.com/kubearmor/kubearmor-client"
  url "https://github.com/kubearmor/kubearmor-client/archive/refs/tags/v1.4.7.tar.gz"
  sha256 "7617d99ff19009a06c9d80d6d723c0d807fdccdefe23e24b44846d0ac90b59ed"
  license "Apache-2.0"
  head "https://github.com/kubearmor/kubearmor-client.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "764c61caaff64616cac78e8726e0209558e8e517bbebdd0b4af0fc55b7ce31b7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ed1e71762f2340d807ac2630d158792725906508bad0cd4f2fa329c91014b3f8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "03dca5c753982e0acd267ed17750dd92ba975ab2f220862c0c78d5df4d66e6a1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "94e47c92fb6b7854091bcadd8af04ba025a36e71afa8446ace42c5dbc0cc7351"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3301dbf3a5063abd2cd0c19865386679e4f6e44cd32c7222d136456135fec92b"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/kubearmor/kubearmor-client/selfupdate.GitSummary=#{version}
      -X github.com/kubearmor/kubearmor-client/selfupdate.BuildDate=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"karmor", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/karmor version")

    expected = if OS.mac?
      "unsupported environment or cluster not configured correctly"
    else
      "Didn't find KubeArmor in systemd or Kubernetes"
    end

    exit_status = OS.mac? ? 1 : 0
    assert_match expected, shell_output("#{bin}/karmor probe 2>&1", exit_status)
  end
end
