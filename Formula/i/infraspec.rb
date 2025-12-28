# framework: cobra
class Infraspec < Formula
  desc "Tool for running infrastructure tests written in pure Gherkin syntax"
  homepage "https://infraspec.sh/"
  url "https://github.com/robmorgan/infraspec/archive/refs/tags/v0.2.0.tar.gz"
  sha256 "268b0b2248303fdaa15357507bacec00c24c8963eef23df85a2a2783414f8ec0"
  license "Apache-2.0"
  head "https://github.com/robmorgan/infraspec.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "406f10b4e273c2fee002e0fb0ee6980de0b1e481339e9fd5fe3bfc74a2d74a92"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "406f10b4e273c2fee002e0fb0ee6980de0b1e481339e9fd5fe3bfc74a2d74a92"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "406f10b4e273c2fee002e0fb0ee6980de0b1e481339e9fd5fe3bfc74a2d74a92"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1ff16df5c0dfbef3b3d891bac058120806c00b4228805cb8e0cf3e9fbbe0c59a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "15aff358a499ea8d7e9bbe5bbd97fc7ad5a619c69163900bf3f736e8c09d6e1a"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/robmorgan/infraspec/internal/build.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/infraspec"

    generate_completions_from_executable(bin/"infraspec", shell_parameter_format: :cobra)
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
    assert_match "Test your AWS infrastructure in plain English, no code required", output
  end
end
