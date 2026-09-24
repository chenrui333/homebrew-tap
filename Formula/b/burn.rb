class Burn < Formula
  desc "See what's burning your Kubernetes budget"
  homepage "https://github.com/tanrikuluozlem/burn"
  url "https://github.com/tanrikuluozlem/burn/archive/refs/tags/v0.5.4.tar.gz"
  sha256 "c0a92700eb928a88853c906a59a6f151ae0d46ef210b4b7e45eacb62558b2104"
  license "Apache-2.0"
  head "https://github.com/tanrikuluozlem/burn.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fb1c158a9d1bf8aac06bdc3a0c0b0c4fdb8b69893e0f35c6da7c20f9bd7f0165"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fb1c158a9d1bf8aac06bdc3a0c0b0c4fdb8b69893e0f35c6da7c20f9bd7f0165"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "22b02fe13168da77df69c2c00bf4cf90c58d1eb95c2e7a1d37ca1ed323eb551c"
    sha256 cellar: :any,                 x86_64_linux:  "fa933e8f0e836ac2d49759c146dc56fb014884cac8f316acac1a9fe648056e25"
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
