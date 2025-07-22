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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "89252445f4f07cddb3822cd5309640a98e82d261cee51c65f3dec4af2b1cd809"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "170c35a9854f58e0bb301931557c587e58a28aa307269ba51b11cf4542daaaa1"
    sha256 cellar: :any_skip_relocation, ventura:       "49b38efc0881385e52f4abefb9620987f6b18ac6954ea120059639ff0d93947c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "46eef1bae8f135834f22101cf863a400ad9148b197b90e42bc174b2e1dbbc976"
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
