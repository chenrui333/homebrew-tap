class Podcli < Formula
  desc "CLI for podinfo"
  homepage "https://github.com/stefanprodan/podinfo"
  url "https://github.com/stefanprodan/podinfo/archive/refs/tags/6.11.2.tar.gz"
  sha256 "a7ff15d25d1e758ed0db695371df93eb578166af1bf32af9546ce78ac1ca605d"
  license "Apache-2.0"
  head "https://github.com/stefanprodan/podinfo.git", branch: "dev"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3e682f5fb0c7fed18efcdaaed9b940c47f6b3fbcf83c0c21f8dc5a9e1355d06c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3e682f5fb0c7fed18efcdaaed9b940c47f6b3fbcf83c0c21f8dc5a9e1355d06c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3e682f5fb0c7fed18efcdaaed9b940c47f6b3fbcf83c0c21f8dc5a9e1355d06c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "529362c7db2aaf82c2af4e99061a7c5c01eb4de9bede5bedb287bf15fbf5a90f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bafda4bfbb773d7223dfe4a1d78b6f98bbedadf376cadf559a102a1647b7b8f6"
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
