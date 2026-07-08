class Burn < Formula
  desc "See what's burning your Kubernetes budget"
  homepage "https://github.com/tanrikuluozlem/burn"
  url "https://github.com/tanrikuluozlem/burn/archive/refs/tags/v0.5.0.tar.gz"
  sha256 "95a8ec39ac8785f53f5bef1614d46297ecb94e166d0766b7fc79c1b01846e6c6"
  license "Apache-2.0"
  head "https://github.com/tanrikuluozlem/burn.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8de7bef20a444d214343ce3aa009eea27e319497086fa08619c9fce1a8e6824d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8de7bef20a444d214343ce3aa009eea27e319497086fa08619c9fce1a8e6824d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8de7bef20a444d214343ce3aa009eea27e319497086fa08619c9fce1a8e6824d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a52c5838630b96a1f23735c380569d36b9b4c7cc6daef36f46a07a556d42413c"
    sha256 cellar: :any,                 x86_64_linux:  "41435b453c26a01fe4d01ed6720fcc763b813be2badee5be7279c66a4afd8af1"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version} -X main.commit=#{tap.user} -X main.date=#{time.iso8601}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/burn"

    generate_completions_from_executable(bin/"burn", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/burn version")

    output = shell_output("#{bin}/burn analyze --ai 2>&1", 1)
    assert_match "try setting KUBERNETES_MASTER environment variable", output
  end
end
