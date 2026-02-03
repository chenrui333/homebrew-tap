class Podcli < Formula
  desc "CLI for podinfo"
  homepage "https://github.com/stefanprodan/podinfo"
  url "https://github.com/stefanprodan/podinfo/archive/refs/tags/6.10.1.tar.gz"
  sha256 "ee776114dbc0e1c8878c7dee5bd60baabe8e77c156e5a0ab6a931ecedebf266e"
  license "Apache-2.0"
  head "https://github.com/stefanprodan/podinfo.git", branch: "dev"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6fd9fb19b68b9ea990c8e37ed8838187aa4215477a46a1c178915457247d799d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6fd9fb19b68b9ea990c8e37ed8838187aa4215477a46a1c178915457247d799d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6fd9fb19b68b9ea990c8e37ed8838187aa4215477a46a1c178915457247d799d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "eba7e87dc371ee3b68ffd9a61de4ff58a574337b12f59517ace6e4a7458425f0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7532db99bb3c66cac6af95f365231b27225fa50cab2b49f2a0f04754e075b496"
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
