class BinJq < Formula
  desc "Jq for binary formats"
  homepage "https://github.com/wader/fq"
  url "https://github.com/wader/fq/archive/refs/tags/v0.15.1.tar.gz"
  sha256 "9f668394c33f3effd02b7d7a145f1087ce784e01d3d0c6e6ba41a899d5e349a7"
  license "Apache-2.0"
  head "https://github.com/wader/fq.git", branch: "master"

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
