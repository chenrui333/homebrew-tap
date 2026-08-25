class BinFq < Formula
  desc "Jq for binary formats"
  homepage "https://github.com/wader/fq"
  url "https://github.com/wader/fq/archive/refs/tags/v0.18.0.tar.gz"
  sha256 "2580de6fb21281a262f99f24d585a925cef71f158c2b24a34125e1b29bc612ef"
  license "Apache-2.0"
  head "https://github.com/wader/fq.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "92765117fb16816140e29a2410e8f3aff57574a425377171985558d2749cbbbf"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "92765117fb16816140e29a2410e8f3aff57574a425377171985558d2749cbbbf"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "92765117fb16816140e29a2410e8f3aff57574a425377171985558d2749cbbbf"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a4e16e017be5981026faef738935cd99b42fe4d0feb3f3a7d9569b7d4ea7c557"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5a767da0dc6f89452113e0ea73ced3a4b9cb596a10be7b6aa2963617f8a54cc0"
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
