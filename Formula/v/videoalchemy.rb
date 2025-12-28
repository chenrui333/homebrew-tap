class Videoalchemy < Formula
  desc "Toolkit expanding video processing capabilities"
  homepage "https://viddotech.github.io/videoalchemy/"
  url "https://github.com/viddotech/videoalchemy/archive/refs/tags/1.0.0.tar.gz"
  sha256 "1ad4ab7e1037a84a7a894ff7dd5e0e3b1b33ded684eace4cadc606632bbc5e3d"
  license "MIT"
  head "https://github.com/viddotech/videoalchemy.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "08f571cd32c29ae75d52b40cb76abb9fd22469f1d7eabe5f23a785126e65dc5d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e9452f35bb3e498e888079d5588523a62f30ac37750e6f831f02959e35f7272d"
    sha256 cellar: :any_skip_relocation, ventura:       "9874d9bdceaa4eb62e3dd562a9767263d670f3f8be5c91202159f519ee18737d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "14264e7e55f9df60fa4f73cf35fa2c7a0d3f305c104d2b126cef2ce4ccac2ae8"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version} -X main.date=#{time.iso8601}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/compose"

    generate_completions_from_executable(bin/"videoalchemy", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/videoalchemy --version")

    (testpath/"test.yaml").write <<~YAML
      version: '1.0'
      tasks:
        - name: "Test Task"
          command: "echo Hello, Videoalchemy!"
    YAML

    output = shell_output("#{bin}/videoalchemy compose -f test.yaml")
    assert_match "Validation Error: generate_path => is required", output
  end
end
