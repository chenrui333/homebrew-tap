class BinFq < Formula
  desc "Jq for binary formats"
  homepage "https://github.com/wader/fq"
  url "https://github.com/wader/fq/archive/refs/tags/v0.16.0.tar.gz"
  sha256 "c0bfc8caa6ecb0ca558a803d704316b1cdde18fda96e77836c0d95c2bcdb2ee6"
  license "Apache-2.0"
  head "https://github.com/wader/fq.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "37dc7bde1a535884933c151cef6bd69eae712406a44bafa5919989976bdc5b7e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "37dc7bde1a535884933c151cef6bd69eae712406a44bafa5919989976bdc5b7e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "37dc7bde1a535884933c151cef6bd69eae712406a44bafa5919989976bdc5b7e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "151b9f944b4763bc3fa20b46f1cd4170d763a34919baa2faca65a76523fd0244"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "034d494b695f167623f14a8590923cac732cfa47b3b9e8007dc9ca79fe8c575d"
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
