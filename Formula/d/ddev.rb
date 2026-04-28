class Ddev < Formula
  desc "Docker-based local PHP+Node.js web development environments"
  homepage "https://ddev.com/"
  url "https://github.com/ddev/ddev/archive/refs/tags/v1.24.7.tar.gz"
  sha256 "c8b487d99f4d4e10eeea58c1833563a38009048b77a9590ff0f04eac851bb98a"
  license "Apache-2.0"
  head "https://github.com/ddev/ddev.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "93fe12aaa975e62c0e0012e88a093f6c48665cd6712930b5896a7313b9aed194"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9a2b4177ec2d9b1861f9ffb49450a12dc6feedd979891a3ea15aa2135f974f84"
    sha256 cellar: :any_skip_relocation, ventura:       "1ea4a13c07bc217995e690565036e40ac367fdd0e0525854aafdf20a9006c7fa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "be38a5324d792bc4fc54c16c1a35a87c82d3f200dbb2f52bdba34aa07b634a18"
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
