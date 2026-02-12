class Omnictl < Formula
  desc "CLI for the Sidero Omni Kubernetes management platform"
  homepage "https://omni.siderolabs.com/"
  url "https://github.com/siderolabs/omni/archive/refs/tags/v1.5.2.tar.gz"
  sha256 "3cbcdbe2de848d3b4a4ff1475782cd6c8d837e37d99602b2c01544e5fbdaa739"
  # license "BSL-1.1"
  head "https://github.com/siderolabs/omni.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "351a5703173c4d2cc9ea0ca32f2ec9d96e55aecf45164cd707b8c9542e4d11a7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "351a5703173c4d2cc9ea0ca32f2ec9d96e55aecf45164cd707b8c9542e4d11a7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "351a5703173c4d2cc9ea0ca32f2ec9d96e55aecf45164cd707b8c9542e4d11a7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8eb00ea146b27af664bb45d03109d9c962eaee186461ed46f53e081e1acd76c8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "762ffba36f9bbe06b7d9c0ebef88993148eb7e8fc6d6609b71d42b8f156297a2"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/omnictl"

    generate_completions_from_executable(bin/"omnictl", shell_parameter_format: :cobra)
  end

  test do
    # assert_match version.to_s, shell_output("#{bin}/omnictl --version")
    system bin/"omnictl", "--version"

    system bin/"omnictl", "config", "new"
    assert_match "Current context: default", shell_output("#{bin}/omnictl config info")

    output = shell_output("#{bin}/omnictl cluster status test 2>&1", 1)
    assert_match "connect: connection refused", output
  end
end
