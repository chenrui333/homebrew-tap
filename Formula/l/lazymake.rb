class Lazymake < Formula
  desc "Terminal UI for browsing and running Makefile targets"
  homepage "https://lazymake.vercel.app/"
  url "https://github.com/rshelekhov/lazymake/archive/refs/tags/v0.4.1.tar.gz"
  sha256 "49dc29635990385fef22717d23c986a62803dc2afeeb428e0a1910711b169c37"
  license "MIT"
  head "https://github.com/rshelekhov/lazymake.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c18e4916a65fe21f8e03b32b47efb7a8389aba87321510951cd02eeaa3ac6aa4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c18e4916a65fe21f8e03b32b47efb7a8389aba87321510951cd02eeaa3ac6aa4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c18e4916a65fe21f8e03b32b47efb7a8389aba87321510951cd02eeaa3ac6aa4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "57d489b6f1abf556cdae525a8bb829035cfcf7acb1b7c1ef9dfda3b332d546ee"
    sha256 cellar: :any,                 x86_64_linux:  "6cd35fc39ae3437643d44564311ef773ca97fe2bacaf65d93f26b08953ff9327"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s
      -w
      -X github.com/rshelekhov/lazymake/version.Version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/lazymake"
    generate_completions_from_executable(bin/"lazymake", shell_parameter_format: :cobra)
  end

  test do
    # FIXME: Upstream does not expose a version command; replace this with a version assertion when available.
    output = shell_output("#{bin}/lazymake --not-a-real-option 2>&1", 1)
    assert_match "unknown flag: --not-a-real-option", output
  end
end
