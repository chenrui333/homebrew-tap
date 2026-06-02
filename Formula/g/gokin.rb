class Gokin < Formula
  desc "AI-powered CLI assistant for code"
  homepage "https://gokin.ginkida.dev"
  url "https://github.com/ginkida/gokin/archive/refs/tags/v0.86.7.tar.gz"
  sha256 "263f82828f914b1bde07a7829390161c620e78fb653fbce1324e6bcd7dc84f30"
  license "MIT"
  head "https://github.com/ginkida/gokin.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8c81f5a5d38a0136e01ac88f3c56bf2e0aaa67ca2884d3da932509a316e8671d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8c81f5a5d38a0136e01ac88f3c56bf2e0aaa67ca2884d3da932509a316e8671d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8c81f5a5d38a0136e01ac88f3c56bf2e0aaa67ca2884d3da932509a316e8671d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ffadaf9361c8603fe761ec10ae49f6a24b8901e268500e31e4263a61a3a8e8bd"
    sha256 cellar: :any,                 x86_64_linux:  "7f11b24fbebba43d392277c13221448ae270c210de6a4e7d953c6c121c8c4f4e"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/gokin"

    generate_completions_from_executable(bin/"gokin", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gokin version")
    assert_match "Available Commands:", shell_output("#{bin}/gokin --help")
  end
end
