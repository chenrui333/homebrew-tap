class Burn < Formula
  desc "See what's burning your Kubernetes budget"
  homepage "https://github.com/tanrikuluozlem/burn"
  url "https://github.com/tanrikuluozlem/burn/archive/refs/tags/v0.5.5.tar.gz"
  sha256 "a5b2cc0dfefdea6a8ace52f7deed557130b351e10e826e6fd9fd0da0d8072bba"
  license "Apache-2.0"
  head "https://github.com/tanrikuluozlem/burn.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "31625216eb451e67044c4ce717ed37635ae30f1265d6ea9148b80eb9a0fc461a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "31625216eb451e67044c4ce717ed37635ae30f1265d6ea9148b80eb9a0fc461a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8fcd65463bfb173660e139ec3bbd36cb2faf37377e2a7447266c413e58afdf13"
    sha256 cellar: :any,                 x86_64_linux:  "81ac7269b20441d06cc45e2f46fbca342aa3e828c5dd8fd3c05dd0572f48d771"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

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
