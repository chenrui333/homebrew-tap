# framework: cobra
class Infraspec < Formula
  desc "Tool for running infrastructure tests written in pure Gherkin syntax"
  homepage "https://github.com/robmorgan/infraspec"
  url "https://github.com/robmorgan/infraspec/archive/refs/tags/v0.8.0.tar.gz"
  sha256 "3103267ec0b5660141182371348dbb953114e07ab87dc10bcd9a1a9799e031fc"
  license "Apache-2.0"
  head "https://github.com/robmorgan/infraspec.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3670fc73de8fa2dff06873205d4a2e617efa2aeaa7f15bfdf0562900b4ad307d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4f06043399d10742f693a22c70587ebc9fa9421ad3e68bfd57d9f1325af4958f"
    sha256 cellar: :any_skip_relocation, ventura:       "fa8d977a0c490807f5d37ae46ab6c5e8c22f9f109d11ef41019e3d5d86e225a2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c214bc8bd9eda34aec32d0181c1529a5503d3b9f741fe8080993ea47f8121d8d"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/robmorgan/infraspec/internal/build.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/infraspec"

    generate_completions_from_executable(bin/"infraspec", "completion", shells: [:bash, :zsh, :fish, :pwsh])
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/infraspec --version")

    (testpath/"test.feature").write <<~EOS
      Feature: Test infrastructure
        Scenario: Check if the infrastructure is up
          Given I have a running server
          When I check the server status
          Then the server should be running
    EOS
    output = shell_output("#{bin}/infraspec test.feature").gsub(/\e\[[;\d]*m/, "")
    assert_match "You can implement step definitions for undefined steps with these snippets", output
  end
end
