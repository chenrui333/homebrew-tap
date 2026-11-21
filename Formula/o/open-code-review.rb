class OpenCodeReview < Formula
  desc "AI-powered code review CLI tool"
  homepage "https://github.com/alibaba/open-code-review"
  url "https://github.com/alibaba/open-code-review/archive/refs/tags/v1.14.0.tar.gz"
  sha256 "98463e5558c70e590ba801d8600b5cff3c90c2a9bce391d33654c9752a47053d"
  license "Apache-2.0"
  head "https://github.com/alibaba/open-code-review.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    manifest_sha256 "0e801a5684d9a29b09d9ddf73e802bcdc89df4d5910e701bf3de6e17165493e5"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2ed9d0ced81ca688bb901199c0a99f812ae8188f02ed8c9173bc6f56c4d1074c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2ed9d0ced81ca688bb901199c0a99f812ae8188f02ed8c9173bc6f56c4d1074c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9f112a99aa8e296ad5cd72106229baae2941598b5bcacdec9fb9fed6167ed2ad"
    sha256 cellar: :any,                 x86_64_linux:  "b399f682b06511ab37682e83283b8d02385267f52af1509f1a324eba93007450"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = "-X main.Version=v#{version}"
    system "go", "build", *std_go_args(output: bin/"ocr", ldflags:), "./cmd/opencodereview"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ocr --version")

    system "git", "init"
    (testpath/"Foo.java").write "class Foo {}\n"
    output = shell_output("#{bin}/ocr rules check #{testpath}/Foo.java")
    assert_match "Source: System built-in", output
    assert_match "Pattern: **/*.java", output
  end
end
