class Karmor < Formula
  desc "Query git repositories with SQL"
  homepage "https://github.com/kubearmor/kubearmor-client"
  url "https://github.com/kubearmor/kubearmor-client/archive/refs/tags/v1.4.3.tar.gz"
  sha256 "c26b5bf0ad09e2a1feaed776ad13d57d702d15abf536bd89f5ab6429cfdc34af"
  license "Apache-2.0"
  head "https://github.com/kubearmor/kubearmor-client.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fcee0d06a10360322478ba29ff06d69a65410f580ae9537d7c32a876d881a89f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e693aad21fdc09cdced0265cd3d09cb3e4307ee076737fe91d4bfb9ed87ff0ff"
    sha256 cellar: :any_skip_relocation, ventura:       "7ff19bb9b02ec09ceccae453a875bfdc4dca6925e298639d1d595c6b00f75b32"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5e5326901782e6048cb0d2b94ef16b8f81a6c1c62e4bab30b95bc1caa8cc9e70"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/kubearmor/kubearmor-client/selfupdate.GitSummary=#{version}
      -X github.com/kubearmor/kubearmor-client/selfupdate.BuildDate=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"karmor", "completion")
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
