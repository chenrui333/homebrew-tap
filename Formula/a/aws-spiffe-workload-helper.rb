class AwsSpiffeWorkloadHelper < Formula
  desc "Helper for providing AWS credentials to workloads using their SPIFFE identity"
  homepage "https://github.com/spiffe/aws-spiffe-workload-helper"
  url "https://github.com/spiffe/aws-spiffe-workload-helper/archive/refs/tags/v0.0.4.tar.gz"
  sha256 "124b009c0dc737c5e5f7afd11eed4fe41b0ac9b98e98fc51cd1a49b38b3e6090"
  license "Apache-2.0"
  head "https://github.com/spiffe/aws-spiffe-workload-helper.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1295faadf091bb2c552f1bf9b8c500cbad6e81a3b3ad1517501af165b8a3b90a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1295faadf091bb2c552f1bf9b8c500cbad6e81a3b3ad1517501af165b8a3b90a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1295faadf091bb2c552f1bf9b8c500cbad6e81a3b3ad1517501af165b8a3b90a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b3bf65d722f81bca07e2685a4a6cadec0a95bdba2c951e98645f4a19e89a1788"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "47374f040d319eb457d001d5ab108f9fcf5e25799d715c30d63d2f59d247d83b"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version}"), "./cmd"

    generate_completions_from_executable(bin/"aws-spiffe-workload-helper",
                                             "completion", shells: [:bash, :zsh, :fish, :pwsh])
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/aws-spiffe-workload-helper --version")

    output = shell_output("#{bin}/aws-spiffe-workload-helper jwt-credential-process " \
                          "--audience test-audience --endpoint http://localhost 2>&1", 1)
    assert_match "Error: creating workload api client: workload endpoint socket address is not configured", output
  end
end
