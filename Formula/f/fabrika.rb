class Fabrika < Formula
  desc "Software factory that orchestrates CLI coding agents as a managed team"
  homepage "https://fabrika-ai.com"
  url "https://github.com/berkaycubuk/fabrika/archive/refs/tags/v0.3.0.tar.gz"
  sha256 "68e745625269ff3ed5d1b9806893432a7f0665a963d7305af07bef41b19b18bb"
  license "FSL-1.1-MIT"
  head "https://github.com/berkaycubuk/fabrika.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4bd9953da39380ee11451111433d83352141b64e39699e41f07d824ecd7dea26"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4bd9953da39380ee11451111433d83352141b64e39699e41f07d824ecd7dea26"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4bd9953da39380ee11451111433d83352141b64e39699e41f07d824ecd7dea26"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "86745dcfcc68f411d7ae0bf3fb7a59b5f6b2a61752f2fe4b67c824ea9c7f9506"
    sha256 cellar: :any,                 x86_64_linux:  "6b41ac327eb907f6542244546fd8465dbedc24e8b03b88ad1c5b7bf7d239ee35"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/fabrika"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/fabrika version")
    output = shell_output("#{bin}/fabrika not-a-real-command 2>&1", 1)
    assert_match "no fabrika.toml", output
  end
end
