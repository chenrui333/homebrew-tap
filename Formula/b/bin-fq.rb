class BinFq < Formula
  desc "Jq for binary formats"
  homepage "https://github.com/wader/fq"
  url "https://github.com/wader/fq/archive/refs/tags/v0.15.1.tar.gz"
  sha256 "9f668394c33f3effd02b7d7a145f1087ce784e01d3d0c6e6ba41a899d5e349a7"
  license "Apache-2.0"
  head "https://github.com/wader/fq.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0e10571e06f0676cdc614302172b87a2562e061f444238d6712d57df724a6f25"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0e10571e06f0676cdc614302172b87a2562e061f444238d6712d57df724a6f25"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0e10571e06f0676cdc614302172b87a2562e061f444238d6712d57df724a6f25"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6c08a74799531419d24c5e09815203ddc882cb47b06c59f6f61209da3ea6256f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5f411a4b2f1fa0eff803912a1d8f6e09ca7c1d8f5056fc68d7ee3625c5e53929"
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
