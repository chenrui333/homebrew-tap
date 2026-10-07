class Unisondb < Formula
  desc "Log-Native, Real-Time Database for AI and Edge Computing"
  homepage "https://unisondb.io/"
  url "https://github.com/ankur-anand/unisondb/archive/4d17a6016c7c04546e29b87ca71cd71a94400bd0.tar.gz"
  version "0.0.1"
  sha256 "a67fff1b1a17db3b3df128d4ae22fe6e3ba33223a8432e95a0aca0adc9fe07e9"
  license "Apache-2.0"
  head "https://github.com/ankur-anand/unisondb.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5102224983d4743d26b188c656f869ac8d96d9af70f46fd67256a6b2ee150863"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c97b6f568da6b5c5496b54e92becc53ed80adaaae7fb10a18a74f723aa8af1f4"
    sha256 cellar: :any,                 arm64_linux:   "6cd7aad72cb48e461228faeaa019572cee975740e81e1e504c9be3c305ba1179"
    sha256 cellar: :any,                 x86_64_linux:  "ae3340596e56e4a738d7c560e6ba636065736c3c5f479cef0e40f9a24e44de79"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    # TODO: remove once upstream no longer pins cockroachdb/swiss b0f6560f979b (fails to build with Go 1.27)
    # https://github.com/cockroachdb/swiss/commit/aa852fb3c14e2d34704a42ee989711108b6f4200
    system "go", "get", "github.com/cockroachdb/swiss@v0.0.0-20260820225851-aa852fb3c14e"
    system "go", "mod", "download"
  end

  def install
    ENV["CGO_ENABLED"] = "1" if OS.linux? && Hardware::CPU.arm?

    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/unisondb"
  end

  test do
    assert_match "Database + Message Bus. Built for Edge", shell_output("#{bin}/unisondb help")
  end
end
