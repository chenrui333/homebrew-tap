class Burn < Formula
  desc "See what's burning your Kubernetes budget"
  homepage "https://github.com/tanrikuluozlem/burn"
  url "https://github.com/tanrikuluozlem/burn/archive/refs/tags/v0.5.3.tar.gz"
  sha256 "6f8472105e277837ac012daf1fb59e650c5e973f4eb498f65dd986865e291f42"
  license "Apache-2.0"
  head "https://github.com/tanrikuluozlem/burn.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0ec422df44bdce2fd5666b5f8ce7886e74978d837225b9510b8ca9cd09bcb4c5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0ec422df44bdce2fd5666b5f8ce7886e74978d837225b9510b8ca9cd09bcb4c5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0ec422df44bdce2fd5666b5f8ce7886e74978d837225b9510b8ca9cd09bcb4c5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cb21e0665809b271bdc73a121bc315c5df9bce1878ccab2a7de9ded0fec9c7ad"
    sha256 cellar: :any,                 x86_64_linux:  "9848a9ac70281450db7d3296b3aa11fb621b7d4dfc743dfd9cb0571ff65fab7d"
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
