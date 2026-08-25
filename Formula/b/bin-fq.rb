class BinFq < Formula
  desc "Jq for binary formats"
  homepage "https://github.com/wader/fq"
  url "https://github.com/wader/fq/archive/refs/tags/v0.18.0.tar.gz"
  sha256 "2580de6fb21281a262f99f24d585a925cef71f158c2b24a34125e1b29bc612ef"
  license "Apache-2.0"
  head "https://github.com/wader/fq.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e5d2d50795112e0ddccb8ce520036341e7d9350561bb019d3192305fd2c0e29b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e5d2d50795112e0ddccb8ce520036341e7d9350561bb019d3192305fd2c0e29b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e5d2d50795112e0ddccb8ce520036341e7d9350561bb019d3192305fd2c0e29b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1733605348f7389bea6bdea05e25b648e57db49aae8570729a72922a0e9a1740"
    sha256 cellar: :any,                 x86_64_linux:  "96dc51a3c7b1fe35d9ad1f8b67c987e959cfa73485461284466c7a16633dc17a"
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
