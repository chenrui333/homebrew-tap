class Lathe < Formula
  desc "Generate hands-on, multi-part technical tutorials on demand"
  homepage "https://github.com/devenjarvis/lathe"
  url "https://github.com/devenjarvis/lathe/archive/refs/tags/v0.4.0.tar.gz"
  sha256 "4f1ec0c9cb44b240e2fe463d0d4180a85ce4e550ce4e592bdfe8e9ebfa088a92"
  license "MIT"
  head "https://github.com/devenjarvis/lathe.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a1346888e1991f1d9e9ece2cb6de2d81cd7fa7cc39170c9db21f833d3a39400d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a1346888e1991f1d9e9ece2cb6de2d81cd7fa7cc39170c9db21f833d3a39400d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a1346888e1991f1d9e9ece2cb6de2d81cd7fa7cc39170c9db21f833d3a39400d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5afda4daafe35ea7ae3f73b0f637540748ebc8935cf63adc491bd0c53fa83528"
    sha256 cellar: :any,                 x86_64_linux:  "b46c47034915e508e3374bf3c1956a736464b9994a9818bc0462878d27041f2c"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/devenjarvis/lathe/internal/buildinfo.Version=v#{version}
    ]
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"lathe", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/lathe version")
    output = shell_output("#{bin}/lathe not-a-real-command 2>&1", 1)
    assert_match "unknown command", output
  end
end
