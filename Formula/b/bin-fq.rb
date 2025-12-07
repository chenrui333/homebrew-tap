class BinFq < Formula
  desc "Jq for binary formats"
  homepage "https://github.com/wader/fq"
  url "https://github.com/wader/fq/archive/refs/tags/v0.16.0.tar.gz"
  sha256 "c0bfc8caa6ecb0ca558a803d704316b1cdde18fda96e77836c0d95c2bcdb2ee6"
  license "Apache-2.0"
  head "https://github.com/wader/fq.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "87bec6a5b897bc083684c779e6726a1aa6aea71d6b119fef69caf2e7c303413c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "87bec6a5b897bc083684c779e6726a1aa6aea71d6b119fef69caf2e7c303413c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "87bec6a5b897bc083684c779e6726a1aa6aea71d6b119fef69caf2e7c303413c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3cc0d463d88c7b4b2268c80fa8eb6c5518eb897a749dcfab4144f72c4a05e24c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3ff8ec3c9ac09920c68cbaa20d6a6aa9fd68a63f7abeaa4951d57bfc7a9bf45c"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version} -X main.commit=#{tap.user} -X main.date=#{time.iso8601}"
    system "go", "build", *std_go_args(ldflags:, output: bin/"fq")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/fq --version")

    out = pipe_output("#{bin}/fq -d json '.[0]'", "[1,2,3]")
    assert_equal "1\n", out
  end
end
