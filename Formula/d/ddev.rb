class Ddev < Formula
  desc "Docker-based local PHP+Node.js web development environments"
  homepage "https://ddev.com/"
  url "https://github.com/ddev/ddev/archive/refs/tags/v1.24.6.tar.gz"
  sha256 "4f28d6a61e5994060d36551ac440b5fab2cc8517cb2524e13cedb77e19fb7b64"
  license "Apache-2.0"
  head "https://github.com/ddev/ddev.git", branch: "main"

  depends_on "go" => :build
  depends_on "docker" => :test

  def install
    ldflags = "-s -w -X github.com/ddev/ddev/pkg/versionconstants.DdevVersion=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/ddev"

    # generate_completions_from_executable(bin/"ddev", "completion", shells: [:bash, :zsh, :fish, :pwsh])
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ddev --version")

    expected = if OS.mac?
      "Could not connect to a Docker provider"
    else
      "No DDEV projects were found."
    end

    ret_status = OS.mac? ? 1 : 0
    assert_match expected, shell_output("#{bin}/ddev list 2>&1", ret_status)
  end
end
