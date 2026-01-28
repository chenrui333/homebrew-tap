class Tock < Formula
  desc "Powerful time tracking tool for the command-line"
  homepage "https://github.com/kriuchkov/tock"
  url "https://github.com/kriuchkov/tock/archive/refs/tags/v1.6.4.tar.gz"
  sha256 "d2cb3853b54dcb88e026c8ebfdf263806c0a8591174448349f6c17de732e3ebd"
  license "GPL-3.0-or-later"
  head "https://github.com/kriuchkov/tock.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "12c25b92af6744e079ab595bda09cbade8659b5b021807b05a898ebe36f71f85"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "12c25b92af6744e079ab595bda09cbade8659b5b021807b05a898ebe36f71f85"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "12c25b92af6744e079ab595bda09cbade8659b5b021807b05a898ebe36f71f85"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a750baf19d9dc05103fb32c9e3e8ef4390a56d87dfa4ce1718e19dd38e9a8833"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9399327a0a803ef1ec3f3f6c611d7ae618d52858c17bd21bcf243f4b0cfd289a"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/kriuchkov/tock/internal/adapters/cli.version=#{version}
      -X github.com/kriuchkov/tock/internal/adapters/cli.commit=#{tap.user}
      -X github.com/kriuchkov/tock/internal/adapters/cli.date=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/tock"

    generate_completions_from_executable(bin/"tock", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/tock --version")
    assert_match "No currently running activities", shell_output("#{bin}/tock current")
  end
end
