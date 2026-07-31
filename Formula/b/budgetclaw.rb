class Budgetclaw < Formula
  desc "Local spend monitor for Claude Code"
  homepage "https://github.com/RoninForge/budgetclaw"
  url "https://github.com/RoninForge/budgetclaw/archive/refs/tags/v1.7.3.tar.gz"
  sha256 "5cca7e3833c000d319bfc9964b47e65127ecd605e6372297b9cf3d8ccee1055a"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a66cd5b3bfdb99cb0ec967aafcb1966abe9765136e3e1fbfbb7c181a1f2d8f10"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f816a1fda88a23cd6caaaac6d33563cc26d7fab515d4fb86fb6a8e810ba4b50b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7838bfe71bcd44aae83fbb13a730d9fb00eb6e8b5e54a0d8424440f2d966f786"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "519e7af36b6f16cc815f35a6c0be6687f1fd1fd732699a83457100b808ece290"
    sha256 cellar: :any,                 x86_64_linux:  "73bf8ceff97b3c8b04d53fc420726ecb23a52321af55634e222bd1b92159168b"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/RoninForge/budgetclaw/internal/version.version=#{version}
      -X github.com/RoninForge/budgetclaw/internal/version.commit=HEAD
      -X github.com/RoninForge/budgetclaw/internal/version.buildDate=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/budgetclaw"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/budgetclaw version")
    assert_match "No activity tracked yet", shell_output("#{bin}/budgetclaw status")
  end
end
