class Lazymake < Formula
  desc "Terminal UI for browsing and running Makefile targets"
  homepage "https://lazymake.vercel.app/"
  url "https://github.com/rshelekhov/lazymake/archive/refs/tags/v0.4.0.tar.gz"
  sha256 "47e99a41c68c92acc81900ee74905e35f9ee97e3dbce4b7f93fd8d56f42d34c3"
  license "MIT"
  head "https://github.com/rshelekhov/lazymake.git", branch: "main"

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s
      -w
      -X github.com/rshelekhov/lazymake/version.Version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/lazymake"
    generate_completions_from_executable(bin/"lazymake", "completion", shell_parameter_format: :cobra)
  end

  test do
    assert_match "bash completion V2", shell_output("#{bin}/lazymake completion bash")
    output = shell_output("#{bin}/lazymake __complete - 2>&1")
    assert_match "--file", output
    assert_match "ShellCompDirectiveNoFileComp", output
  end
end
