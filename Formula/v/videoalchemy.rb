class Videoalchemy < Formula
  desc "Toolkit expanding video processing capabilities"
  homepage "https://viddotech.github.io/videoalchemy/"
  url "https://github.com/viddotech/videoalchemy/archive/refs/tags/1.0.0.tar.gz"
  sha256 "1ad4ab7e1037a84a7a894ff7dd5e0e3b1b33ded684eace4cadc606632bbc5e3d"
  license "MIT"
  head "https://github.com/viddotech/videoalchemy.git", branch: "main"

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version} -X main.date=#{time.iso8601}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/compose"

    generate_completions_from_executable(bin/"videoalchemy", "completion", shells: [:bash, :zsh, :fish, :pwsh])
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
