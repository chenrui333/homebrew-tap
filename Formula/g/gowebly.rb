class Gowebly < Formula
  desc "Next-generation CLI tool to easily build amazing web applications"
  homepage "https://gowebly.org/"
  url "https://github.com/gowebly/gowebly/archive/refs/tags/v3.0.0.tar.gz"
  sha256 "4f12b7bbbef2cdd16c37748bc75aff2362987c93eb26f4dfc4dcfe2689811274"
  license "Apache-2.0"
  head "https://github.com/gowebly/gowebly.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "94e5894b5ad19faaba15e776f839635f14ec3d55545261678cf31ed7c855122d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0fbe91d7c53170cb60eaaf7a35dc0498296d57e7a286dc61cc837ebc3335d2bc"
    sha256 cellar: :any_skip_relocation, ventura:       "ecae498510e4b82251e9deec212a663ae2d0b1e54285c3bc6f758a0cacfafde2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "30f0e7129e638a5f8c64a97384e08d479f2cedfe5d17b82fcefb7321ee5a9520"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gowebly doctor")

    output = shell_output("#{bin}/gowebly run 2>&1", 1)
    assert_match "No rule to make target", output
  end
end
