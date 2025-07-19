class Ddev < Formula
  desc "Docker-based local PHP+Node.js web development environments"
  homepage "https://ddev.com/"
  url "https://github.com/ddev/ddev/archive/refs/tags/v1.24.7.tar.gz"
  sha256 "c8b487d99f4d4e10eeea58c1833563a38009048b77a9590ff0f04eac851bb98a"
  license "Apache-2.0"
  head "https://github.com/ddev/ddev.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e4f644eeb3ed8bae8e5a4670d0763ab7c3ec3b8d14ca967683e3b8e70f4ef8f1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a72cc99acc202f5ddf881befdca8a43aae38580fd9d009a6ef6ed7eff80ca647"
    sha256 cellar: :any_skip_relocation, ventura:       "2458bf1a49c50e329854fdb9bf619242dfd95ed23df8273806c9da1a6e7e473e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4a3f898ee25a6808025a7531594c5e5cb528069226f0b47afa1c6a8042344ee1"
  end

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
