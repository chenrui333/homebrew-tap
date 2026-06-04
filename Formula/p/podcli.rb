class Podcli < Formula
  desc "CLI for podinfo"
  homepage "https://github.com/stefanprodan/podinfo"
  url "https://github.com/stefanprodan/podinfo/archive/refs/tags/6.13.0.tar.gz"
  sha256 "4de7262e7905e912103a593a36aa3c64daf6b3689860f14819bf0b5022d46fa5"
  license "Apache-2.0"
  head "https://github.com/stefanprodan/podinfo.git", branch: "dev"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "76fac3fd46b73cfebbf70b5a42a6c2547393ba9f4adfe015971915b2896f852a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "76fac3fd46b73cfebbf70b5a42a6c2547393ba9f4adfe015971915b2896f852a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "76fac3fd46b73cfebbf70b5a42a6c2547393ba9f4adfe015971915b2896f852a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6dcbf6792dc6a2607f2090a876b4e7f7e6f8e08d448a8531f40f77a2ef99bb39"
    sha256 cellar: :any,                 x86_64_linux:  "4af511bbbf901a58f211c1191a982436111e53c94cedb9652ed506956754f9d8"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/stefanprodan/podinfo/pkg/version.REVISION=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/podcli"

    generate_completions_from_executable(bin/"podcli", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/podcli version")

    output = shell_output("#{bin}/podcli check http https://httpbin.org 2>&1")
    assert_match "check succeed", output
  end
end
