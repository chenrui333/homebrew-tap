class FissionCli < Formula
  desc "Fast and Simple Serverless Functions for Kubernetes"
  homepage "https://fission.io/"
  url "https://github.com/fission/fission/archive/refs/tags/v1.21.0.tar.gz"
  sha256 "c1419492151dca5a2fe5f11a51ca50147ab068c2d860609b17e8ad060198e359"
  license "Apache-2.0"
  head "https://github.com/fission/fission.git", branch: "main"

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/fission/fission/pkg/info.Version=#{version}
      -X github.com/fission/fission/pkg/info.GitCommit=#{tap.user}
      -X github.com/fission/fission/pkg/info.BuildDate=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:, output: bin/"fission"), "./cmd/fission-cli"

    generate_completions_from_executable(bin/"fission", "completion", shells: [:bash, :zsh, :fish, :pwsh])
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/fission version")
    system bin/"fission", "support", "dump"
  end
end
