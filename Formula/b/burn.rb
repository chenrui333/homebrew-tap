class Burn < Formula
  desc "See what's burning your Kubernetes budget"
  homepage "https://github.com/tanrikuluozlem/burn"
  url "https://github.com/tanrikuluozlem/burn/archive/refs/tags/v0.3.5.tar.gz"
  sha256 "cc4aa76e1c667b9a1f50af73b8638c8a7e9d09d1ac3fa5cb7bed57bd9d78457f"
  license "Apache-2.0"
  head "https://github.com/tanrikuluozlem/burn.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e4d7f70c9b22266a3d0348584839ff01693a246c8c2904ec1fdce99036f50da9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e4d7f70c9b22266a3d0348584839ff01693a246c8c2904ec1fdce99036f50da9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e4d7f70c9b22266a3d0348584839ff01693a246c8c2904ec1fdce99036f50da9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bf4266fb3de9dc758ac1252fa84658a9c8422cdbb096a6f721b2e3a9792a4035"
    sha256 cellar: :any,                 x86_64_linux:  "699ce263e39e42040a3de39f59fb5683db7179855c322c3586df80c305a9ff8d"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.commit=HEAD
      -X main.date=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/burn"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/burn version")
    output = shell_output("#{bin}/burn not-a-real-command 2>&1", 1)
    assert_match "unknown command", output
  end
end
