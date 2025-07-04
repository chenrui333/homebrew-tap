# framework: cobra
class Infraspec < Formula
  desc "Tool for running infrastructure tests written in pure Gherkin syntax"
  homepage "https://github.com/robmorgan/infraspec"
  url "https://github.com/robmorgan/infraspec/archive/refs/tags/v0.0.6.tar.gz"
  sha256 "e06992bc160674a7cba9642177284811d511760798dd58bd7d1ec6d9d5a69987"
  license "Apache-2.0"
  head "https://github.com/robmorgan/infraspec.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "264db927d148744277b4612546659d13ca97e64fc8e80cb6e0df5c22ac9a058d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "dfbc37a15cc1fd7fd3367bd82d166fb1d7d10fdecbeeb1e77e50e73c690cc866"
    sha256 cellar: :any_skip_relocation, ventura:       "01176807fa0dec0ab2d6ab7401f79d61240dc0bf394ef722e2e327d73becb5ee"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0b70927c908db2a7530aae1f5b76c2be0ceb945bca054568d099e1a979e21be1"
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
